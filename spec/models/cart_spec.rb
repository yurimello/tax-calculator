require_relative '../../app/models/cart'

RSpec.describe Cart do
  describe '#initialize' do
    it 'creates an empty cart' do
      cart = Cart.new

      expect(cart.products).to eq([])
    end

    it 'initializes products as an array' do
      cart = Cart.new

      expect(cart.products).to be_an(Array)
    end
  end

  describe '#products' do
    it 'allows adding products to the cart' do
      cart = Cart.new
      product = double('product')

      cart.products << product

      expect(cart.products.length).to eq(1)
      expect(cart.products.first).to eq(product)
    end

    it 'allows multiple products to be added' do
      cart = Cart.new
      product1 = double('product1')
      product2 = double('product2')
      product3 = double('product3')

      cart.products << product1
      cart.products << product2
      cart.products << product3

      expect(cart.products.length).to eq(3)
    end
  end

  describe '#full_price' do
    it 'returns 0 for empty cart' do
      cart = Cart.new

      expect(cart.full_price).to eq(0)
    end

    it 'calculates full price for single product' do
      cart = Cart.new
      product = double('product', full_price: 12.49)
      cart.products << product

      expect(cart.full_price).to eq(12.49)
    end

    it 'calculates full price for multiple products' do
      cart = Cart.new
      product1 = double('product1', full_price: 12.49)
      product2 = double('product2', full_price: 16.49)
      product3 = double('product3', full_price: 0.85)

      cart.products << product1
      cart.products << product2
      cart.products << product3

      expect(cart.full_price).to eq(29.83)
    end

    it 'calculates full price including taxes for taxable items' do
      cart = Cart.new
      product1 = double('product1', full_price: 16.49)
      product2 = double('product2', full_price: 20.89)

      cart.products << product1
      cart.products << product2

      expect(cart.full_price).to eq(37.38)
    end

    it 'calculates full price for mixed exempt and taxable items' do
      cart = Cart.new
      product1 = double('product1', full_price: 12.49)
      product2 = double('product2', full_price: 16.49)

      cart.products << product1
      cart.products << product2

      expect(cart.full_price).to eq(28.98)
    end

    it 'calculates full price for imported items' do
      cart = Cart.new
      product1 = double('product1', full_price: 10.50)
      product2 = double('product2', full_price: 54.65)

      cart.products << product1
      cart.products << product2

      expect(cart.full_price).to eq(65.15)
    end
  end

  describe '#sales_tax' do
    it 'returns 0 for empty cart' do
      cart = Cart.new

      expect(cart.sales_tax).to eq(0)
    end

    it 'returns 0 for cart with only exempt items' do
      cart = Cart.new
      product1 = double('product1', tax: 0.0)
      product2 = double('product2', tax: 0.0)
      product3 = double('product3', tax: 0.0)

      cart.products << product1
      cart.products << product2
      cart.products << product3

      expect(cart.sales_tax).to eq(0.0)
    end

    it 'calculates sales tax for single taxable product' do
      cart = Cart.new
      product = double('product', tax: 1.50)
      cart.products << product

      expect(cart.sales_tax).to eq(1.50)
    end

    it 'calculates sales tax for multiple taxable products' do
      cart = Cart.new
      product1 = double('product1', tax: 1.50)
      product2 = double('product2', tax: 1.90)

      cart.products << product1
      cart.products << product2

      expect(cart.sales_tax).to eq(3.40)
    end

    it 'calculates sales tax for mixed exempt and taxable items' do
      cart = Cart.new
      product1 = double('product1', tax: 0.0)
      product2 = double('product2', tax: 1.50)
      product3 = double('product3', tax: 0.0)

      cart.products << product1
      cart.products << product2
      cart.products << product3

      expect(cart.sales_tax).to eq(1.50)
    end

    it 'calculates sales tax including import tax for imported items' do
      cart = Cart.new
      product1 = double('product1', tax: 0.50)
      product2 = double('product2', tax: 7.15)

      cart.products << product1
      cart.products << product2

      expect(cart.sales_tax).to eq(7.65)
    end

    it 'calculates sales tax for complex mixed cart' do
      cart = Cart.new
      product1 = double('product1', tax: 0.50)
      product2 = double('product2', tax: 7.15)
      product3 = double('product3', tax: 0.0)
      product4 = double('product4', tax: 1.50)

      cart.products << product1
      cart.products << product2
      cart.products << product3
      cart.products << product4

      expect(cart.sales_tax).to eq(9.15)
    end
  end
end
