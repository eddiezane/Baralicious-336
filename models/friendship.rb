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
    errbody = Drinker.all_drinkers
    errbody.each do |drinker1|
      rand(15..30).times do
        drinker2 = errbody.sample
        next if drinker1.name >= drinker2.name
        score = 0.2
        score += rand(0.4) if drinker1.city == drinker2.city
        score += rand(0.5) if drinker1.same_street? drinker2
        score *= (1 + drinker1.frequents.count {|bar| bar.frequented_by? drinker2})

        Friendship.new(drinker1.name, drinker2.name).add_to_db if score >= 0.45
      end
    end
  end
end
