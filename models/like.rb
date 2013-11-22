class Like
  attr_reader :drinker, :beer

  def initialize drinker, beer
    @drinker = drinker
    @beer = beer
  end

  def add_to_db
    # puts ("INSERT INTO `likes` VALUES('#{@drinker}', '#{@beer})")
    $client.query("INSERT INTO `likes` VALUES('#{@drinker}', '#{@beer.gsub("'","''")}')")
  end

  def self.add_ze_likes
    drinkers = $client.query("SELECT * FROM `drinkers`").to_a.map! {|drinker| drinker['name']}
    beers = $client.query("SELECT * FROM `beers`").to_a.map! {|beer| beer['name']}
    drinkers.each do |drinker|
      likes = []
      # number of beers somebody likes
      rand(10).times do
        beer = beers.sample
        if not likes.include? beer
          likes << beer
          Like.new(drinker, beer).add_to_db
        end
      end
    end
  end
end
