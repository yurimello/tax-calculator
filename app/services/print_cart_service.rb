class PrintCartService
  def self.call(cart)
    new(cart).call
  end

  def initialize(cart)
    @cart = cart
  end

  def call
    @cart.products.each do |product|
      puts product.to_s
    end
    puts "Sales Taxes: #{'%.2f' % @cart.sales_tax}"
    puts "Total: #{'%.2f' % @cart.total}"
  end
end