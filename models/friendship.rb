class Friendship
  attr_reader :drinker1, :drinker2

  def initialize drinker1, drinker2
    @drinker1 = drinker1
    @drinker2 = drinker2
  end

  def add_to_db
    client.query("INSERT INTO `friendships` VALUES('#{@drinker1}', '#{@drinker2})")
  end

  def self.add_ze_franz
    errbody = client.query("SELECT name FROM `drinkers`").to_a
    errbody.map! { |drinker| drinker[:name]}
    errbody.each do |drinker1|
      # number of friends times
      (rand(10) + 1).times do
        drinker2 = errbody.sample
        next if friend1 >= friend2
        Friendship.new(friend1, friend2).add_to_db
      end
    end
  end
end
