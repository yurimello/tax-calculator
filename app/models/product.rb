class Product
  TAX_RATE = 0.10
  IMPORT_TAX_RATE = 0.05
  EXEMPT_CATEGORIES = %w[book food medical]
  attr_reader :name, :net_price, :quantity, :category, :imported

  def initialize(name, net_price, quantity, category, imported = false)
    @name = name
    @net_price = net_price
    @quantity = quantity
    @category = category
    @imported = imported
  end

  def total_price
    @net_price * @quantity
  end

  def full_price
    (total_price + tax).round(2)
  end
  
  def tax
    # Tax is calculated per item then multiplied by quantity
    tax_per_item = @net_price * total_tax_rate
    rounded_tax_per_item = round_up_to_nearest_005(tax_per_item)
    (rounded_tax_per_item * @quantity).round(2)
  end

  def to_s
    "#{quantity} #{name}: #{'%.2f' % full_price}"
  end

  private

  def total_tax_rate
    (tax_rate + import_tax_rate).round(2)
  end

  def tax_rate
    exempt? ? 0 : TAX_RATE
  end

  def import_tax_rate
    imported ? IMPORT_TAX_RATE : 0
  end

  def exempt?
    EXEMPT_CATEGORIES.include?(category)
  end

  def round_up_to_nearest_005(amount)
    (amount * 20).ceil / 20.0
  end
end