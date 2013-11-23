class Drinker
  attr_reader :name, :city, :phone, :address


  def initialize name, city = nil, phone = nil, address = nil
    @name = name
    @city = city || random_city.capitalize
    @phone = phone || generate_phone(@city)
    @address = address || generate_address(@city)
  end

  def add_to_db
    $client.query("INSERT INTO `drinkers` VALUES('#{@name.capitalize}'," +
                  " '#{@city.capitalize}', '#{@phone}', '#{@address.capitalize}')")
  end

  def self.add_ze_drinkers
    names_file = File.open('./seed_data/babynames.txt', 'r')

    names_file.each_line do |name|
      drinker = Drinker.new name.strip
      drinker.add_to_db
    end
  end

  def friends
    $client.query("SELECT name, city, phone, addr FROM (SELECT * FROM `drinkers` JOIN `friendships` ON drinkers.name = friendships.drinker1 WHERE friendships.drinker1 = '#{@name}' OR friendships.drinker2 = '#{@name}' UNION ALL SELECT * FROM `drinkers` JOIN `friendships` ON drinkers.name = friendships.drinker2 WHERE friendships.drinker1 = '#{@name}' OR friendships.drinker2 = '#{@name}') AS T WHERE name <> '#{@name}';").to_a.map do |fran|
      Drinker.new(fran['name'], fran['city'], fran['phone'], fran['addr'])
    end
  end

  def frequents
    $client.query("SELECT name, license, city, phone, addr FROM `bars` JOIN frequents ON bars.name = frequents.bar WHERE frequents.drinker = '#{@name}'").to_a.map do |bar|
      Bar.new(bar['name'], bar['city'], bar['license'], bar['phone'], bar['addr'])
    end
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

  return "#{rand(1000)} #{street_names.sample.capitalize}"
  end
end
