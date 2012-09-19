require_relative 'lib/checkout.rb'
require_relative 'lib/reevoo_pricing.rb'
require "test/unit"

class TestReevoo < Test::Unit::TestCase

  def setup
  	@co = Checkout.new(ReevooPricing.new)
  end

  def test_data1
    %w(FR1 SR1 FR1 CF1).each{ |sku| @co.scan(sku.to_sym) }
    assert_equal(22.25, @co.total)
  end

  def test_data2
    %w(FR1 FR1).each{ |sku| @co.scan(sku.to_sym) }
    assert_equal(3.11, @co.total)
  end

  def test_data3
    %w(SR1 SR1 FR1 SR1).each{ |sku| @co.scan(sku.to_sym) }
    assert_equal(16.61, @co.total)
  end



end