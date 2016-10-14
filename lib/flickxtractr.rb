require "flickxtractr/version"

module Flickxtractr
  autoload :App, 'flickxtractr/app'
  autoload :Dotfile, 'flickxtractr/dotfile'
  autoload :Extractr, 'flickxtractr/extractr'

  def self.dotfile
    @_dotfile ||= Dotfile.new
  end
end
