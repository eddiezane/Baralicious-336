require 'mysql2'
require './models/bar.rb'
require './models/drinker.rb'
require './models/friendship.rb'
require './models/beer.rb'
require './models/sell.rb'
require './models/like.rb'

$client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")

# database shit
$client.query("DROP DATABASE IF EXISTS `beer`;")
$client.query("CREATE DATABASE `beer`;")
$client.select_db "beer"
`mysql -ucsuser --password=c0rnd0gs -D beer < baralicious.sql`

Bar.add_ze_bars
Drinker.add_ze_drinkers
Friendship.add_ze_franz
Beer.add_ze_beers
Sell.add_ze_sells
Like.add_ze_likes
