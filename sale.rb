class Sale
  attr_reader :date, :bar, :beer, :price, :drinker

  def initialize date, bar, beer, price = nil, drinker
    @date = time_rand
  end

  def add_to_db
  end

  def time_rand from = Time.local(2013, 1, 1), to = Time.now
    time = Time.at(from + rand * (to.to_f - from.to_f))

    case
  end
end
