require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sinatra/json'
require 'mysql2'
require './beeralicious'

# configure
set :public_folder, File.dirname(__FILE__) + '/assets'
set :bind, '0.0.0.0'




get '/' do
  haml :index
end

get '/drinkers' do
  @drinker ||= Drinker.all_drinkers.map {|drinker| drinker.name}
  json @drinker
end

get 'drinkers/:drinker' do
  @drinker = Drinker.get_drinker_by_name
  haml :drinker
end
