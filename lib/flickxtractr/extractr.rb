require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

module Flickxtractr
  class Extractr
    include Capybara::DSL

    attr_reader :url

    def initialize(url)
      @url = url

      initialize_capybara!
    end

    def generate_image!
      generate_image_file!
    end

    def page_image_uri
      @_page_image_uri ||= begin
        find(:css, "div.download").click
        within("div.download ul.sizes") do
          URI(find(:xpath, "./li[@class='Original']/a")[:href])
        end
      end
    end

    def generated_image_file_name
      "#{Date.today.strftime("%Y%m%d")}_#{generated_image_slug}"
    end

    def generated_image_slug
      page_image_title.gsub(/\W+/, '-').downcase.gsub(/\A-|-\Z/, '')
    end

    def page_image_title
      find(:css, "h1.photo-title").text
    end

    private

    def initialize_capybara!
      Capybara.current_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
      visit(url)
    end

    def generate_image_file!
      File.open("#{generated_image_file_name}.#{page_image_uri.path.match(/\.(.+?)\z/)[1]}", "wb").tap do |f|
        Net::HTTP.start(page_image_uri.host) do |http|
          begin
            http.request_get(page_image_uri.path) do |resp|
              resp.read_body do |segment|
                f.write(segment)
              end
            end
          ensure
            f.close
          end
        end
      end
    end
  end
end
