class Drinker
  attr_reader :name, :city, :phone, :address

  def self.add_ze_drinkers
    names_file = File.open('./seed_data/babynames.txt', 'r')

    names_file.each_line do |name|
      drinker = Drinker.new name.strip
      drinker.add_to_db
    end
  end

  def self.get_drinker_by_name name
    drinker = $client.query("SELECT * FROM `drinkers` WHERE name='#{name}'").to_a[0]
    return Drinker.new(drinker['name'], drinker['city'], drinker['phone'], drinker['addr']) if not drinker.nil?
    nil
  end

  def self.all_drinkers
    $all_drinkers ||= $client.query("SELECT * FROM `drinkers`").map do |drinker|
      Drinker.new(drinker['name'], drinker['city'], drinker['phone'], drinker['addr'])
    end
    return $all_drinkers
  end

  def initialize name, city = nil, phone = nil, address = nil
    @name = name
    @city = city || random_city.capitalize
    @phone = phone || generate_phone(@city)
    @address = address || generate_address(@city)
  end

  def == another_drinker
    return @name == another_drinker.name
  end

  def add_to_db
    $client.query("INSERT INTO `drinkers` VALUES('#{@name.capitalize}'," +
                  " '#{@city.capitalize}', '#{@phone}', '#{@address.capitalize}')")
  end

  def transactions
    @transactions ||= $client.query("SELECT date, bar, beer, price FROM transactions where drinker='#{@name}'").to_a.map do |transaction|
      Transaction.new(transaction['date'], transaction['bar'], transaction['beer'], transaction['price'], transaction['drinker'])
    end
    return @transactions
  end

  def bought beer
    $client.query("SELECT * FROM `transactions` WHERE transactions.drinker = '#{@name}' AND transactions.beer = '#{beer.name.gsub("'","''")}'").to_a.map do |transaction|
      Transaction.new(transaction['date'], transaction['bar'], transaction['beer'], transaction['price'], transaction['drinker'])
    end
  end

  def friends
    @friends ||= $client.query("SELECT name, city, phone, addr FROM (SELECT * FROM `drinkers` JOIN `friendships` ON drinkers.name = friendships.drinker1 WHERE friendships.drinker1 = '#{@name}' OR friendships.drinker2 = '#{@name}' UNION ALL SELECT * FROM `drinkers` JOIN `friendships` ON drinkers.name = friendships.drinker2 WHERE friendships.drinker1 = '#{@name}' OR friendships.drinker2 = '#{@name}') AS T WHERE name <> '#{@name}';").to_a.map do |fran|
      Drinker.new(fran['name'], fran['city'], fran['phone'], fran['addr'])
    end
    return @friends
  end

  def frequents
    @frequents ||= $client.query("SELECT name, license, city, phone, addr FROM `bars` JOIN frequents ON bars.name = frequents.bar WHERE frequents.drinker = '#{@name}'").to_a.map do |bar|
      Bar.new(bar['name'], bar['city'], bar['license'], bar['phone'], bar['addr'])
    end
    return @frequents
  end

  def frequents_with drinker
    $client.query("SELECT * FROM `bars` WHERE bars.name IN (SELECT bar FROM `frequents` WHERE frequents.drinker = '#{@name}') AND bars.name IN (SELECT bar FROM `frequents` WHERE frequents.drinker = '#{drinker.name}')").to_a.map do |bar|
      Bar.new(bar['name'], bar['city'], bar['license'], bar['phone'], bar['addr'])
    end
  end

  def likes
    @likes ||= $client.query("SELECT name, manf FROM `beers` JOIN `likes` ON beers.name = likes.beer WHERE likes.drinker = '#{@name}'").to_a.map do |beer|
      Beer.new(beer['name'], beer['manf'])
    end
    return @likes
  end

  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  def random_city
    return ['new york', 'new brunswick', 'trenton', 'philadelphia'].sample.capitalize
  end

  def generate_phone city = 'new york'
    case city.downcase
    when 'new york'
      num = '212'
    when 'new brunswick'
      num = '732'
    when 'trenton'
      num = '609'
    when 'philadelphia'
      num = '215'
    end

  3.times {num += '5'}
  4.times {num += rand(10).to_s}

  return num
  end

  def generate_address city = 'new york'
    case city.downcase
    when 'new york'
      name_file = File.open('./seed_data/street_names/ny.txt', 'r')
    when 'new brunswick'
      name_file = File.open('./seed_data/street_names/nb.txt', 'r')
    when 'trenton'
      name_file = File.open('./seed_data/street_names/trenton.txt', 'r')
    when 'philadelphia'
      name_file = File.open('./seed_data/street_names/pa.txt', 'r')
    end

  street_names = []
  name_file.each_line do |line|
    street_names.push line.strip
  end

  def same_street? other_drinker
    if @city == other_drinker.city and @address.split[0] == other_drinker.address.split[0]
      true
    else
      false
    end
  end

  return "#{rand(1000)} #{street_names.sample.capitalize}"
  end
end
