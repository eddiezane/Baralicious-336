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

  def time_rand from = Time.local(2013, 1, 1), to = Time.now
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
    drinkers = $client.query("SELECT * FROM `drinkers`").to_a
    frequents = $client.query("SELECT * FROM `frequents`").to_a
    sells = $client.query("SELECT * FROM `sells`").to_a

  end

end
