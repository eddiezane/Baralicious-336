class Frequent
  attr_reader :drinker, :bar

  def initialize drinker, bar
    @drinker = drinker
    @bar = bar
  end

  def add_to_db
    $client.query("INSERT INTO `frequents` VALUES('#{@drinker.name}', '#{@bar.name.gsub("'","''")}')")
  end

  def self.add_ze_frequents
    drinkers = $client.query("SELECT * FROM `drinkers`").to_a.map do |drinker|
      Drinker.new(drinker['name'], drinker['city'], drinker['phone'], drinker['address'])
    end

    bars = $client.query("SELECT * FROM `bars`").to_a.map do |bar|
      Bar.new(bar['name'], bar['license'], bar['city'], bar['phone'], bar['addr'])
    end

    frequents = []

    drinkers.each do |drinker|
      # range of number of frequents
      rand(1..5).times do
        bar = bars.sample
        frequent = {drinker.name => bar.name}
        if not frequents.include? frequent 
          frequents << frequent
          Frequent.new(drinker, bar).add_to_db
        end
      end
    end
  end
end
