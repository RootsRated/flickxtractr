require 'sinatra'

class Flickxtractr < Sinatra::Base
  set :erb, :format => :html5

  get '/' do
    erb :home
  end

  post '/extract' do
    "Extract!"
  end
end
