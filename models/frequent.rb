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
    puts ("INSERT INTO `frequents` VALUES('#{@drinker}', '#{@bar})")
  end

  def self.add_ze_frequents
    drinkers = $client.query("SELECT name FROM `drinkers`").to_a
    bars = $client.query("SELECT name FROM `bars`").to_a
    drinkers.each do |drinker|
      frequented_bars = []

      # number of bars somebody frequents
      rand(4).times do
        bar = bars.sample

        if not frequented_bars.include? bar['name']
          if drinker['city'] == bar['city']
            frequented_bars.push bar['name'] if rand(3) == 1
          else
            frequented_bars.push bar['name'] if rand(10) == 1
          end
        end
      end
      frequented_bars.each {|bar| Frequent.new(drinker['name'], bar).add_to_db}
    end
  end
end

Frequent.add_ze_frequents
