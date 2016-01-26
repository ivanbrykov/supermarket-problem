require_relative 'lib/checkout.rb'
require_relative 'lib/pricing_dsl.rb'
require 'test/unit'

class Pricing1 < PricingDSL
  declare_product :FR1, 'Fruit tea', 3.11
  declare_product :SR1, 'Strawberries', 5.0
  declare_product :CF1, 'Coffee', 11.23

  buy_one_get_one_free :FR1
  bulk_price :SR1, 3, 4.5
end

class Pricing2 < PricingDSL
  declare_product :FR1, 'Fruit tea', 3.11
  declare_product :SR1, 'Strawberries', 5.0
  declare_product :CF1, 'Coffee', 11.23

  bulk_price :FR1, 2, 3.01
end


class TestSupermarket < Test::Unit::TestCase

  def test_data1
    co = Checkout.new(Pricing2.new)
    %w(FR1 SR1 FR1 CF1).each{ |sku| co.scan(sku.to_sym) }
    assert_equal(22.25, co.total)
  end

  def test_data2
    co = Checkout.new(Pricing1.new)
    %w(FR1 FR1).each{ |sku| co.scan(sku.to_sym) }
    assert_equal(3.11, co.total)
  end

  def test_data3
    co = Checkout.new(Pricing1.new)
    %w(SR1 SR1 FR1 SR1).each{ |sku| co.scan(sku.to_sym) }
    assert_equal(16.61, co.total)
  end



end