require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'mini_exiftool'

module Flickxtractr
  class Extractr
    include Capybara::DSL

    attr_reader :url

    def initialize(url)
      @url = url

      initialize_capybara!
    end

    def generate_image!
      image_file = generate_image_file!
      apply_meta_from_extract!(image_file)
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

    def generated_image_file_name_with_extension
      "#{generated_image_file_name}.#{page_image_uri.path.match(/\.(.+?)\z/)[1]}"
    end

    def generated_screenshot_file_name
      "#{generated_image_file_name}_screenshot.png"
    end

    def generated_image_slug
      page_image_title.gsub(/\W+/, '-').downcase.gsub(/\A-|-\Z/, '')
    end

    def page_image_title
      find(:css, "h1.photo-title").text
    end

    def page_image_description
      all(:css, "h2.photo-desc p").collect(&:text).join("\n")
    end

    def page_image_keywords
      tag_links = all(:css, "ul.tags-list li a")
      tag_links.collect { |a| a[:title] unless a.has_selector?(".remove-tag") }.compact.join("; ")
    end

    def page_owner_name
      find(:css, "div.attribution-info a.owner-name.truncate").text
    end

    def page_owner_profile
      "https://www.flickr.com#{find(:css, "div.attribution-info a.owner-name.truncate")[:href]}"
    end

    private

    def initialize_capybara!
      Capybara.current_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
      visit(url)
    end

    def generate_image_file!
      File.open(File.join(Flickxtractr.dotfile.output_dir, generated_image_file_name_with_extension), "wb").tap do |f|
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

    def generate_page_screenshot!
      page.save_screenshot(File.join(Flickxtractr.dotfile.screenshot_dir, generated_screenshot_file_name), full: true)
    end

    def apply_meta_from_extract!(image_file)
      MiniExiftool.new(image_file.path).tap do |rmi|
        image_meta.each { |k, v| rmi[k] = v }
        rmi.save
      end
    end

    def image_meta
      {
        "Headline"     => page_image_title,
        "Description"  => page_image_description,
        "Keywords"     => page_image_keywords,
        "Credit Line"  => page_owner_name,
        "Instructions" => url,
      }
    end
  end
end
