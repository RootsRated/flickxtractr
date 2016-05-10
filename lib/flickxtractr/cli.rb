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
  end
end
