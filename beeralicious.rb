require 'time'
require 'mysql2'
require './models/bar.rb'
require './models/drinker.rb'
require './models/friendship.rb'
require './models/beer.rb'
require './models/sell.rb'
require './models/like.rb'
require './models/frequent.rb'
require './models/transaction.rb'

$client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs", reconnect: true)
$client.select_db "beer2"

def link_to object
  case
    when object.is_a?(Beer)
      return "<a class=\"black\" href=/beers/#{object.name}>object.name</a>"
    when object.is_a?(Drinker)
      return "<a class=\"black\" href=/drinkers/#{object.name.gsub(" ","%20")}>#{object.name}</a>"
    when object.is_a?(Bar)
      return "<a class=\"black\" href=/bars/#{object.name.gsub(" ","%20")}>#{object.name}</a>"
  end
end
