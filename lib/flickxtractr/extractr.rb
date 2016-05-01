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

    private

    def initialize_capybara!
      Capybara.current_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
      visit(url)
    end
  end
end
