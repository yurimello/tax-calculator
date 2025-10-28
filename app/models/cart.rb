class Cart
  attr_accessor :products

  def initialize
    @products = []
  end

  def full_price
    @products.sum(&:full_price).round(2)
  end

  def sales_tax
    @products.sum(&:tax).round(2)
  end
end