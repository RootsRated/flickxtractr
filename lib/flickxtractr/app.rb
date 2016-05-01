require 'sinatra'

module Flickxtractr
  class App < Sinatra::Base
    set :erb, :format => :html5
    set :views, ['./app/views']

    get '/' do
      erb :home
    end

    post '/extract' do
      "Extract!"
    end
  end
end
