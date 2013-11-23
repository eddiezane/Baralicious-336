class Transaction
  attr_reader :drinker, :date, :bar, :beer, :price

  def initialize drinker = nil, date = nil, bar = nil, beer = nil, price = nil
    @date = date || time_rand
    @bar = bar || "Some random bar"
    @beer = beer || "Heineken"
    @price = price || 2.59
    @drinker = drinker
  end

  def add_to_db
    puts "INSERT INTO `transactions` VALUES('#{@date}', '#{@bar.capitalize}'," +
         " '#{@drinker.name}', '#{@beer}', '#{@price}')"
    # client.query("INSERT INTO `transactions` VALUES('#{@date}', '#{@bar.capitalize}'," +
    #              " '#{@drinker}', '#{@beer}', '#{@price}')"
  end

  def random_time from = Time.local(2013, 1, 1), to = Time.now
    time = Time.at(from + rand * (to.to_f - from.to_f))

    case time.day
      when 0 #sunday
        weight = 0.1
      when 1 #monday
        weight = 0.25
      when 2 #tuesday
        weight = 0.4
      when 3 #wednesday
        weight = 0.5
      when 4 #thursday
        weight = 0.75
      when 5 #friday
        weight = 0.85
      when 6 #saturday
        weight = 0.9
    end

  return time
  end

  def self.add_ze_transactions
    bars = $client.query("SELECT * FROM `bars`").to_a.map do |bar|
      Bar.new(bar['name', bar['city'], bar['license'], bar['phone'], bar['address'])
    end

    drinkers = $client.query("SELECT * FROM `drinkers`").map do |drinker|
      Drinker.new(drinker['name'], drinker['city'], drinker['phone'], drinker['address'])
    end

    drinkers.each do |drinker|
      friends = drinker.friends

      500.times do
        time = random_time
        bar = bars.sample

        num_friends = bar.frequents.count {|x| 

        Transacation.new(drinker.name, date, bar.name, beer.name, price).add_to_db if score > 10
      end



    end

  end

end
