class PricingRules

  # product config storage
  @@products = {}

  # new product registration routine
  def self.declare_product(sku, name, price)
    @@products[sku] = {:name => name, :price => lambda { |sku_list| price } }
  end

  # buy-one-get-one-free discount definition
  def self.buy_one_get_one_free(sku)
    raise 'No such product declared yet' unless @@products[sku]
    price = @@products[sku][:price].call(nil)
    count = 0
    @@products[sku][:price] = lambda do |sku_list|
      count += 1
      count.odd? ? price : 0.0
    end
  end

  # bulk discount definition
  def self.bulk_discount(sku, qty, new_price)
    raise 'No such product declared yet' unless @@products[sku]
    price = @@products[sku][:price].call(nil)
    @@products[sku][:price] = lambda do |sku_list|
      sku_list.select{ |s| s==sku }.count>=qty ? new_price : price
    end
  end

  # convert a list of SKUs into list of corresponding prices
  def get_prices(sku_list)
    sku_list.collect do |sku|
      raise "No product is declared with sku #{sku}" unless @@products[sku]
      @@products[sku][:price].call(sku_list)
    end
  end

end