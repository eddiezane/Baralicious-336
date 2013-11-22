class Drinker
  attr_reader :name, :city, :phone, :address

  def initialize name, city = 'new york'
    @name = name
    @city = city || 'New York'
    @phone = generate_phone city
    @address = generate_address city
  end

  def add_to_db
    puts "INSERT INTO `drinkers` VALUES('#{@name.capitalize}'," +
      "'#{@city.capitalize}', '#{@phone}'," +
      "'#{@address.capitalize}')"
    # client.query("INSERT INTO `drinkers` VALUES('#{drinker.name.capitalize}'," +
    #             "'#{drinker.city.capitalize}', '#{drinker.phone}'," +
    #             "'#{drinker.address}')")
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
        name_file = File.open('.street_names/ny.txt', 'r')
      when 'new brunswick'
        name_file = File.open('.street_names/nb.txt', 'r')
      when 'trenton'
        name_file = File.open('.street_names/trenton.txt', 'r')
      when 'philadelphia'
        name_file = File.open('.street_names/pa.txt', 'r')
    end

    street_names = []
    name_file.each_line do |line|
      street_names.push line
    end

    return "#{rand(1000)} #{names[rand(names.size)].capitalize}"
  end
end


