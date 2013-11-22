require 'mysql2'

client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")
names = File.open("babynames.txt", "r")
streets = File.open("streetnames.txt", "r")

# database shit
client.query("DROP DATABASE IF EXISTS `beer`;")
client.query("CREATE DATABASE `beer`;")
client.select_db 'beer'

def create_drinker name, street_name
  addr = "#{(Random.rand * 1000).floor.to_s} #{street_name}"
  phone = generate_hp
  10.times do
    phone += (Random.rand * 10).floor.to_s
  end
  puts "INSERT INTO `drinkers` VALUES ('#{name.capitalize}','New York','#{phone}',#{addr})"
  # client.query("INSERT INTO `drinkers` VALUES ('#{name.capitalize}','New York','#{phone}',#{addr})",)
end


def generate_phone area_code

end
