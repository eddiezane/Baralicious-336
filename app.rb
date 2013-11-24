require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sinatra/json'
require 'mysql2'
require './beeralicious'

# configure
set :public_folder, File.dirname(__FILE__) + '/assets'
set :port, 4567
set :bind, '0.0.0.0'


get '/' do
  haml :index, :layout => :splash
end

get '/drinkers' do
  @drinkers ||= Drinker.all_drinkers.map {|drinker| drinker.name}
  json @drinkers
end

get '/drinkers/:drinker' do |drinker|
  @drinker = Drinker.get_drinker_by_name(drinker)
  error 404 if @drinker.nil?
  haml :drinker
end

get '/bars' do
  @bars ||= Bar.all_bars.map {|bar| bar.name}
  json @bars
end

get '/bars/:barname' do |bar|
  @bar = Bar.get_bar_by_name bar
  error 404 if @bar.nil?
  haml :bar
end

error 404 do
  "<h1>This is not the page you were looking for</h1>"
end
