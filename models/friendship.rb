class Friendship
  attr_reader :drinker1, :drinker2

  def initialize drinker1, drinker2
    @drinker1 = drinker1
    @drinker2 = drinker2
  end

  def add_to_db
    $client.query("INSERT INTO `friendships` VALUES('#{@drinker1}', '#{@drinker2}')")
    # puts("INSERT INTO `friendships` VALUES('#{@drinker1}', '#{@drinker2}')")
  end

  def self.add_ze_franz
    errbody = all_drinkers
    Drinker errbody.each do |drinker1|
      (15..30).times do
        drinker2 = errbody.sample
        next if drinker1 >= drinker2
        score = 0
        score += rand(0.5..0.75) if drinker1.city == drinker2.city
        res = $client.query("SELECT bar FROM `frequents` WHERE drinker = '#{drinker1}' AND bar = (SELECT bar FROM `frequents` WHERE drinker = '#{drinker2}' LIMIT 1)").to_a
        if not res.empty?
          score *= 1.5
        end
        if score >= 0.75
          Friendship.new(drinker1, drinker2).add_to_db
        end
      end
    end
  end
end
