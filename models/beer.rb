class Beer
  require 'csv'
  attr_reader :name, :manf

  def initialize name, manf
    @name = name
    @manf = manf
  end

  def self.add_ze_beers
    manfs = []
    names = []

    CSV.foreach('./seed_data/beer_data/openbeerdb_csv/breweries.csv') do |row|
      if row[1] and row[1].ascii_only?
        manfs << {id: row[0], name: row[1]}
      end
    end

    CSV.foreach('./seed_data/beer_data/openbeerdb_csv/beers.csv') do |row|
      if row[2] and row[2].ascii_only?
        manfs.each do |manf|
          if row[1] == manf[:id] and not names.include? row[2].downcase
            Beer.new(row[2], manf[:name]).add_to_db
            names.push row[2].downcase
          end
        end
      end
    end
  end

  def add_to_db
    $client.query("INSERT INTO `beers` VALUES('#{@name.gsub("'","''")}', '#{@manf.gsub("'","''")}');")
    # puts ("INSERT INTO `beers` VALUES('#{@name}', '#{@manf}');")
  end
end
