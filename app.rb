require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sinatra/json'
require 'mysql2'
require './beeralicious'
require 'haml'

# configure
set :public_folder, File.dirname(__FILE__) + '/assets'
set :port, 4567
set :bind, '0.0.0.0'


get '/' do
  haml :index, :layout => :splash
end


# API
get '/bars.json' do
  @bars ||= Bar.all_bars.map {|bar| bar.name}
  json @bars
end

get '/drinkers.json' do
  @drinkers ||= Drinker.all_drinkers.map {|drinker| drinker.name}
  json @drinkers
end

get '/beers.json' do
  @beers ||= Beer.all_beers.map {|beer| beer.name}
  json @beers
end


# drinkers
get '/drinkers/:drinker' do |drinker|
  @drinker = Drinker.get_drinker_by_name params[:drinker]
  error 404 if @drinker.nil?
  haml :drinker
end

post '/drinkers' do
  @drinker = Drinker.get_drinker_by_name params[:drinker]
  error 404 if @drinker.nil?
  haml :drinker
end


# beers
post '/beers' do
  @beer = Beer.get_beer_by_name params[:beer]
#  error 404 if @bar.nil?
  haml :beer
end


# bars
get '/bars/:bar' do |bar|
  @bar = Bar.get_bar_by_name bar
  error 404 if @bar.nil?
  haml :bar
end

post '/bars' do
  @bar = Bar.get_bar_by_name params[:bar]
  error 404 if @bar.nil?
  haml :bar
end

error 404 do
  "<h1>This is not the page you were looking for</h1>"
end
