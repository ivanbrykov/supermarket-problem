class Checkout

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    @pricing_rules.get_prices(@items).inject(&:+)
  end

end