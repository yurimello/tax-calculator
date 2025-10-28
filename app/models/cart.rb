class Cart
  attr_accessor :products

  def initialize
    @products = []
  end

  def full_price
    @products.map(&:full_price).sum
  end

  def sales_tax
    @products.map(&:sales_tax).sum
  end
end