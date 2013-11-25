class Sell
  attr_reader :bar, :beer, :price

  def initialize bar, beer, price
    @bar = bar
    @beer = beer
    @price = price
  end

  def add_to_db
    $client.query("INSERT INTO `sells` VALUES('#{@bar.gsub("'","''")}', '#{@beer.gsub("'","''")}', '#{price}')")
  end

  def self.add_ze_sells
    bars = $client.query("SELECT * FROM `bars`").to_a
    beers = $client.query("SELECT * FROM `beers`").to_a

    bars.each do |bar|
      gbeers = []
      rand(5..50).times do
        beer = beers.sample['name']
        if not gbeers.include? beer
          gbeers << beer
          price = "#{rand(1..20)}.#{['00','50'].sample}"
          Sell.new(bar['name'], beer, price).add_to_db
        end
      end
    end
  end
end
