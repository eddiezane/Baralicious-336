require 'mysql2'

$client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")
$client.select_db 'beer'

class Frequent
  attr_reader :drinker, :bar

  def initialize drinker, bar
    @drinker = drinker
    @bar = bar
  end

  def add_to_db
    # $client.query("INSERT INTO `frequents` VALUES('#{@drinker}', '#{@bar})")
    puts ("INSERT INTO `frequents` VALUES('#{@drinker}', '#{@bar.gsub("'","''")}')")
  end

  def self.add_ze_frequents
    drinkers = $client.query("SELECT * FROM `drinkers`").to_a.map do |drinker|
      Drinker.new(drinker['name'], drinker['city'], drinker['phone'], drinker['address'])
    end

    bars = $client.query("SELECT * FROM `bars`").to_a

    drinkers.each do |drinker|
      match_percent = 1.0
      bar = bars.sample
      bar_frequents = $client.query("SELECT * FROM `frequents` WHERE bar = '#{bar['name']}'").to_a

    end
  end

end

Frequent.add_ze_frequents
