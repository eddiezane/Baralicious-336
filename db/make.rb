require 'mysql2'
require '../models/bar.rb'
require '../models/drinker.rb'
require '../models/friendship.rb'
require '../models/beer.rb'
require '../models/sell.rb'
require '../models/like.rb'
require '../models/frequent.rb'
require '../models/transaction.rb'

$client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")

# database shit
$client.query("DROP DATABASE IF EXISTS `beer`;")
$client.query("CREATE DATABASE `beer`;")
$client.select_db "beer"
`mysql -ucsuser --password=c0rnd0gs -D beer < baralicious.sql`

gtimer = start = Time.now
puts "Adding ze drinkers..."
Drinker.add_ze_drinkers
puts "Took #{Time.now - start}"
puts "Adding ze bars..."
start = Time.now
Bar.add_ze_bars
puts "Took #{Time.now - start}"
puts "Adding ze beers..."
start = Time.now
Beer.add_ze_beers
puts "Took #{Time.now - start}"
puts "Adding ze frequents..."
start = Time.now
Frequent.add_ze_frequents
puts "Took #{Time.now - start}"
puts "Adding ze franz..."
start = Time.now
Friendship.add_ze_franz
puts "Took #{Time.now - start}"
puts "Adding ze sells..."
start = Time.now
Sell.add_ze_sells
puts "Took #{Time.now - start}"
puts "Adding ze likes..."
start = Time.now
Like.add_ze_likes
puts "Took #{Time.now - start}"
puts "Adding ze trannies..."
start = Time.now
Transaction.add_ze_trannies
puts "Took #{Time.now - start}"
puts "DONE!!! -- Total time: #{Time.now - gtimer}"
