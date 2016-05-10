require 'flickxtractr'
require 'thor'

module Flickxtractr
  class CLI < Thor
    package_name 'Flickxtractr'

    desc "install", "Install library dependencies"
    def install
      %w{ exiftool phantomjs }.each do |dependency|
        `brew install #{dependency}`
      end
    end

    desc "extract URL", "Extract and enrich flickr image"
    def extract(flickr_url)
      print_extract_output("Loading", "Loading","Loading","Loading","Loading")

      extractr = Flickxtractr::Extractr.new(flickr_url)
      clear_output! && print_extract_output(
        extractr.page_image_title,
        extractr.page_image_description,
        extractr.page_owner_name,
        "Generating . . .",
        "Generating . . .",
      )

      extractr.generate_image!

      clear_output! && print_extract_output(
        extractr.page_image_title,
        extractr.page_image_description,
        extractr.page_owner_name,
        extractr.generated_image_file_name_with_extension,
        extractr.generated_screenshot_file_name,
      )
    end

    private

    def print_extract_output(title, description, author, download, screenshot)
      print <<-EOF
        ---------------------------------------------------
        Name               #{title}
        Description        #{description}
        Author             #{author}
        - - - - - - - - - - - - - - - - - - - - - - - - - -
        Download           #{download}
        Screenshot         #{screenshot}
        ---------------------------------------------------
      EOF
      STDOUT.flush
    end

    def clear_output!
      8.times { print "\033[A", "\033[K" }
    end
  end
end
