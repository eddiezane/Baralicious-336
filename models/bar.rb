class Bar
  attr_reader :name, :city, :license, :phone, :addr

  def initialize name, city = nil, license = nil, phone = nil, address = nil
    @name = name
    @city = city || random_city.capitalize
    @license = license || generate_license(@city)
    @phone = phone || generate_phone(@city)
    @address = address || generate_address(@city)
  end

  def self.all_bars
    $client.query("SELECT * FROM `bars`").to_a.map do |bar|
      Bar.new(bar['name'], bar['city'], bar['license'], bar['phone'], bar['address'])
    end
  end

  def self.add_ze_bars
    names = File.open('./seed_data/babynames.txt').to_a.map{|w| w.strip.capitalize}
    prefixes = File.open('./seed_data/bar_names/bar_prefixes.txt').to_a.map{|w| w.strip.capitalize}
    types = ['Bar', 'Tavern', 'Pub', 'Inn', 'Establishment', 'Beer Garden', 'Club', 'Beer Hall']

    bars = []

    # Number of bars
    rand(25..50).times do
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
    @sells ||= $client.query("select name, manf from beers join sells on beers.name = sells.beer where sells.bar ='#{@name.gsub("'","''")}';").to_a.map do |beer|
      Beer.new(beer['name'], beer['manf'])
    end
    return @sells
  end

  def frequents
    @frequents ||= $client.query("SELECT name, city, phone, addr FROM drinkers JOIN frequents ON drinkers.name = frequents.drinker WHERE frequents.bar = '#{@name.gsub("'","''")}';").to_a.map do |x|
      Drinker.new(x['name'], x['city'], x['phone'], x['addr'])
    end
    return @frequents
  end

  def price_of beer
    $client.query("SELECT price FROM `sells` WHERE beer='#{beer.name.gsub("'","''")}' AND bar='#{@name.gsub("'","''")}'").to_a[0]['price'].to_f
  end

  def frequented_by? drinker
    $client.query("SELECT * FROM `frequents` WHERE bar='#{@name.gsub("'","''")}' AND drinker='#{drinker.name}'").to_a.size > 0
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
    case city.downcase
      when 'new york'
        license = 'NY'
      when 'philadelphia'
        license = 'PA'
      else
        license = 'NJ'
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
