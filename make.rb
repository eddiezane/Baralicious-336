require 'mysql2'
require './models/bar'
require './models/drinker'
require './models/friendship'
require './models/sale'
require './models/like'

client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")
names = File.open("babynames.txt", "r")
streets = File.open("streetnames.txt", "r")

# database shit
client.query("DROP DATABASE IF EXISTS `beer`;")
client.query("CREATE DATABASE `beer`;")
client.select_db 'beer'

