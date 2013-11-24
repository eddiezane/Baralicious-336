class Beer
  require 'csv'
  attr_reader :name, :manf

  def initialize name, manf
    @name = name
    @manf = manf
  end

  def == another_beer
    return (@name == another_beer.name and @manf == another_beer.manf)
  end

  def self.all_beers
    $client.query("SELECT * FROM `beers`").map do |beer|
      Beer.new(beer['name'], beer['manf'])
    end
  end

  def liked_by
    @likes ||= $client.query("SELECT name, city, phone, addr FROM `drinkers` JOIN `likes` ON drinkers.name = likes.drinker WHERE likes.beer = '#{@name.gsub("'","''")}';").to_a.map do |drinker|
      Drinker.new(drinker['name'], drinker['city'], drinker['phone'], drinker['addr'])
    end
    return @likes
  end

  def self.get_beer_by_name name
    beer = $client.query("SELECT * FROM `beers` WHERE name='#{name}'").to_a[0]
    return Beer.new(beer['name'], beer['manf']) if not beer.nil?
    nil
  end

  def self.add_ze_beers
    manfs = []
    names = []

    nums = []
    count = 0
    100.times do
      nums << rand(4759)
    end

    CSV.foreach('./seed_data/beer_data/openbeerdb_csv/breweries.csv') do |row|
      if row[1] and row[1].ascii_only?
        manfs << {id: row[0], name: row[1]}
      end
    end

    CSV.foreach('./seed_data/beer_data/openbeerdb_csv/beers.csv') do |row|
      count += 1
      if row[2] and row[2].ascii_only?
        manfs.each do |manf|
          if row[1] == manf[:id] and not names.include? row[2].downcase and nums.include? count
            Beer.new(row[2], manf[:name]).add_to_db
            names.push row[2].downcase
          end
        end
      end
    end
  end

  def sold_at
    $client.query("SELECT name, city, license, phone, addr FROM `bars` JOIN `sells` ON bars.name = sells.bar WHERE sells.beer = '#{@name}';").to_a.map do |bar|
      Bar.new(bar['name'], bar['city'], bar['license'], bar['phone'], bar['addr'])
    end
  end

  def add_to_db
    $client.query("INSERT INTO `beers` VALUES('#{@name.gsub("'","''")}', '#{@manf.gsub("'","''")}');")
    # puts ("INSERT INTO `beers` VALUES('#{@name}', '#{@manf}');")
  end
end
