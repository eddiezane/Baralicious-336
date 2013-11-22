require 'mysql2'

$client = Mysql2::Client.new(host: "localhost", username: "csuser", password: "c0rnd0gs")
$client.select_db 'beer'

class Bar
  attr_reader :name, :license, :city, :phone, :addr

  def initialize name
    @name = name
    @city = random_city.capitalize
    @license = generate_license(@city)
    @phone = generate_phone(@city)
    @address = generate_address(@city)
  end

  def self.add_ze_bars
    names = File.open('../seed_data/babynames.txt').to_a.map{|w| w.strip.capitalize}
    prefixes = File.open('../seed_data/bar_names/bar_prefixes.txt').to_a.map{|w| w.strip.capitalize}
    types = ['Bar', 'Tavern', 'Pub', 'Inn', 'Establishment', 'Beer Garden', 'Club', 'Beer Hall']

    rand(1000).times do
      Bar.new("#{prefixes.sample} #{names.sample}'s #{types.sample}").add_to_db
    end
  end

  def add_to_db
    #$client.query("INSERT INTO `bars` VALUES('#{@name}', '#{@license}', " +
    #              " '#{@city}', '#{@phone}', '#{@address}')")
    puts "INSERT INTO `bars` VALUES('#{@name}', '#{@license}', " +
                  " '#{@city}', '#{@phone}', '#{@address}')"
  end

  def random_city
    return ['New York', 'New Brunswick', 'Trenton', 'Philadelphia'].sample
  end

  def generate_license city
    license = ''
    case city.downcase
      when 'new york'
        license += 'NY'
      when 'philadelphia'
        license += 'PA'
      else
        license += 'NJ'
    end

    5.times do
      license += (0..9).to_a.sample.to_s
    end
    license
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


Bar.add_ze_bars
