class CartCheckoutService
  def self.call(file_path)
    cart = CartImporterService.call(file_path)
    PrintCartService.call(cart)
  end
end