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
    (total_price * total_tax_rate).round(2)
  end

  def to_s
    "#{quantity} #{name}: #{full_price}"
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
end