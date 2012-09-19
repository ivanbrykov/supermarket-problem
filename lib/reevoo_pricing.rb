require_relative 'pricing_rules.rb'

class ReevooPricing < PricingRules

  # somewhat convinient DSL to manage all rules

  declare_product :FR1, 'Fruit tea', 3.11
  declare_product :SR1, 'Strawberries', 5.0
  declare_product :CF1, 'Coffee', 11.23

  buy_one_get_one_free :FR1
  bulk_discount :SR1, 3, 4.5

end