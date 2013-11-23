class Bar
  attr_reader :name, :city, :license, :phone, :addr

  def initialize name, city = nil, license = nil, phone = nil, address = nil
    @name = name
    @city = city || random_city.capitalize
    @license = license || generate_license(@city)
    @phone = phone || generate_phone(@city)
    @address = address || generate_address(@city)
  end

  def self.add_ze_bars
    names = File.open('./seed_data/babynames.txt').to_a.map{|w| w.strip.capitalize}
    prefixes = File.open('./seed_data/bar_names/bar_prefixes.txt').to_a.map{|w| w.strip.capitalize}
    types = ['Bar', 'Tavern', 'Pub', 'Inn', 'Establishment', 'Beer Garden', 'Club', 'Beer Hall']

    bars = []

    rand(10..50).times do
      pref = prefixes.sample
      name = names.sample
      type = types.sample
      bar = {a: pref, b: name, c: type}
      if not bars.include? bar
        bars << bar
        Bar.new("#{pref} #{name}''s #{type}").add_to_db
      end
    end
  end

  def sells
    $client.query("SELECT * FROM `sells` WHERE bar = '#{@name}'")to_a.map do |x|
      Sell.new(x['bar'], x['beer'], x['price'])
    end
  end

  def frequents
    $client.query("SELECT * FROM `frequents` WHERE bar = '${@name}'").to_a.map do |x|
      Frequent.new(x['drinker'], x['bar'])
    end
  end

  def add_to_db
    $client.query("INSERT INTO `bars` VALUES('#{@name}', '#{@license}', " +
                  " '#{@city}', '#{@phone}', '#{@address}')")
    # puts "INSERT INTO `bars` VALUES('#{@name}', '#{@license}', " +
    #              " '#{@city}', '#{@phone}', '#{@address}')"
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
