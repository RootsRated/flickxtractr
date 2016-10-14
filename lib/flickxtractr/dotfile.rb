require 'delegate'
require 'hashie/mash'
require 'yaml'

module Flickxtractr
  class Dotfile < SimpleDelegator

    TEMPLATE_PATH = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'dotfile.yml')
    DOTFILE_FILENAME = ".flickxtractr"

    class << self
      def install
        FileUtils.copy TEMPLATE_PATH, path
      end

      def path
        File.join(user_path, DOTFILE_FILENAME)
      end

      def exists?
        File.exist? path
      end

      private

      def user_path
        Dir.home rescue ENV.fetch('HOME', "/")
      end
    end

    def initialize
      dotfile_path = File.exist?(self.class.path) ? self.class.path : TEMPLATE_PATH
      super Hashie::Mash.new YAML.load_file(dotfile_path)
    end
  end
end
