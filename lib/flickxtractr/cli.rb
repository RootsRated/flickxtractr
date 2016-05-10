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
      extractr = Flickxtractr::Extractr.new(flickr_url)
      extractr.generate_image!
    end
  end
end
