class PricingDSL
  class << self
    attr_accessor :products
  end

  # new product registration routine
  def self.declare_product(sku, name, price)
    self.products ||= {}
    self.products[sku] = {name: name, price: Proc.new { |sku_list, idx| price }}
  end

  # buy-one-get-one-free discount definition
  def self.buy_one_get_one_free(sku)
    self.products ||= {}
    raise 'No such product declared yet' unless self.products[sku]
    price = self.products[sku][:price].call
    self.products[sku][:price] = Proc.new do |sku_list, idx|
      count = sku_list[0..idx].count{|item|item==sku}
      count.odd? ? price : 0.0
    end
  end

  # bulk discount definition
  def self.bulk_price(sku, qty, new_price)
    self.products ||= {}
    raise 'No such product declared yet' unless self.products[sku]
    price = self.products[sku][:price].call
    self.products[sku][:price] = Proc.new do |sku_list, idx|
      sku_list.select{ |s| s==sku }.count>=qty ? new_price : price
    end
  end

  # convert a list of SKUs into list of corresponding prices
  def get_prices(sku_list)
    sku_list.collect.with_index do |sku, idx|
      raise "No product is declared with sku #{sku}" unless self.class.products[sku]
      self.class.products[sku][:price].call(sku_list, idx)
    end
  end

end