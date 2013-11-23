require 'time'

class Transaction
  attr_reader :date, :bar, :beer, :price, :drinker

  def initialize date, bar, beer, price, drinker
    @date = date
    @bar = bar
    @beer = beer
    @price = price
    @drinker = drinker
  end

  def add_to_db
    puts("INSERT INTO `transactions` VALUES('#{@date}', '#{@bar.gsub("'","''")}', '#{@beer}', '#{@price}', '#{@drinker}')")
    $client.query("INSERT INTO `transactions` VALUES('#{@date}', '#{@bar.gsub("'","''")}', '#{@beer}', '#{@price}', '#{@drinker}')")
  end

  def self.random_time
    time = Time.at(Time.local(2013, 1, 1) + rand * (Time.now.to_f - Time.local(2013, 1, 1).to_f))

    case
      when time.sunday?
        weight = 0.1
      when time.monday?
        weight = 0.25
      when time.tuesday?
        weight = 0.4
      when time.wednesday?
        weight = 0.5
      when time.thursday?
        weight = 0.75
      when time.friday?
        weight = 0.85
      when time.saturday?
        weight = 0.9
    end

    case time.hour
      when (3...11)
        weight = 0
      when (11...14)
        weight += 0.15
      when (14...17)
        weight += 0.3
      when (17...19)
        weight += 0.6
      when (19...21)
        weight += 0.5
      when (21...24)
        weight += 0.8
      when (24...3)
        weight += 0.7
    end

    return {time: time.to_s, weight: weight}
  end

  def self.add_ze_trannies
    bars = Bar.all_bars
    drinkers = Drinker.all_drinkers

    drinkers.each do |drinker|
      likes = drinker.likes
      friends = drinker.friends
      rand(3..5).times do
        time = random_time
        score = time[:weight] * rand
        bar = bars.sample

        # penalties
        score -= 0.3 if drinker.city != bar.city

        # bonuses
        score *= (1.0 + (friends.count {|friend| bar.frequents.include? friend} / friends.count.to_f)) unless friends.count == 0
        score *= (1.0 + (likes.count {|beer| bar.sells.include? beer} / likes.count.to_f)) unless likes.count == 0
        beer = bar.sells.sample

        Transaction.new(time[:time], bar.name, beer.name, bar.price_of(beer), drinker.name).add_to_db if score > 1
      end
    end
  end

end
