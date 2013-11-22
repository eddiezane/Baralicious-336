require 'mysql2'

$client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")
$client.select_db 'beer'

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
        name_file = File.open('../seed_data/street_names/ny.txt', 'r')
      when 'new brunswick'
        name_file = File.open('../seed_data/street_names/nb.txt', 'r')
      when 'trenton'
        name_file = File.open('../seed_data/street_names/trenton.txt', 'r')
      when 'philadelphia'
        name_file = File.open('../seed_data/street_names/pa.txt', 'r')
    end

    street_names = []
    name_file.each_line do |line|
      street_names.push line.strip
    end

    return "#{rand(1000)} #{street_names.sample.capitalize}"
  end
end

  names_file = File.open('../seed_data/babynames.txt', 'r')

  names_file.each_line do |name|
    drinker = Drinker.new name.strip
    drinker.add_to_db
  end

