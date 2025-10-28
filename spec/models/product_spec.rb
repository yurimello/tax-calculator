require_relative '../../app/models/product'

RSpec.describe Product do
  describe '#initialize' do
    it 'creates a product with required attributes' do
      product = Product.new('book', 12.49, 1, 'book')

      expect(product.name).to eq('book')
      expect(product.net_price).to eq(12.49)
      expect(product.quantity).to eq(1)
      expect(product.category).to eq('book')
    end

    it 'defaults imported to false when not specified' do
      product = Product.new('book', 12.49, 1, 'book')

      expect(product.imported).to be_falsey
    end

    it 'accepts imported parameter' do
      product = Product.new('imported perfume', 27.99, 1, 'other', true)

      expect(product.imported).to be true
    end
  end

  describe '#total_price' do
    it 'calculates total price for single item' do
      product = Product.new('book', 12.49, 1, 'book')

      expect(product.total_price).to eq(12.49)
    end

    it 'calculates total price for multiple items' do
      product = Product.new('chocolate bar', 0.85, 3, 'food')

      expect(product.total_price).to eq(2.55)
    end
  end

  describe '#tax' do
    context 'for exempt categories' do
      it 'calculates no tax for book' do
        product = Product.new('book', 12.49, 1, 'book')

        expect(product.tax).to eq(0.0)
      end

      it 'calculates no tax for food' do
        product = Product.new('chocolate bar', 0.85, 1, 'food')

        expect(product.tax).to eq(0.0)
      end

      it 'calculates no tax for medical' do
        product = Product.new('headache pills', 9.75, 1, 'medical')

        expect(product.tax).to eq(0.0)
      end
    end

    context 'for non-exempt categories' do
      it 'calculates 10% tax for regular items' do
        product = Product.new('music CD', 14.99, 1, 'other')

        expect(product.tax).to eq(1.50)
      end

      it 'calculates tax correctly for multiple quantities' do
        product = Product.new('perfume', 18.99, 2, 'other')

        expect(product.tax).to eq(3.80)
      end
    end

    context 'for imported items' do
      it 'adds 5% import tax to exempt items' do
        product = Product.new('imported box of chocolates', 10.00, 1, 'food', true)

        expect(product.tax).to eq(0.50)
      end

      it 'adds 5% import tax to regular items (15% total)' do
        product = Product.new('imported perfume', 27.99, 1, 'other', true)
        expect(product.full_price).to eq(32.19)
        expect(product.tax).to eq(4.2)

      end
    end
  end

  describe '#full_price' do
    it 'calculates full price including tax for exempt item' do
      product = Product.new('book', 12.49, 1, 'book')

      expect(product.full_price).to eq(12.49)
    end

    it 'calculates full price including tax for taxable item' do
      product = Product.new('music CD', 14.99, 1, 'other')

      expect(product.full_price).to eq(16.49)
    end

    it 'calculates full price including tax for imported item' do
      product = Product.new('imported box of chocolates', 10.00, 1, 'food', true)

      expect(product.full_price).to eq(10.50)
    end

    it 'calculates full price including tax for imported taxable item' do
      product = Product.new('imported perfume', 27.99, 1, 'other', true)

      expect(product.full_price).to eq(32.19)
    end
  end

  describe '#to_s' do
    it 'formats product as string with quantity and name' do
      product = Product.new('book', 12.49, 1, 'book')

      expect(product.to_s).to eq('1 book: 12.49')
    end

    it 'formats product with multiple quantities' do
      product = Product.new('chocolate bar', 0.85, 3, 'food')

      expect(product.to_s).to eq('3 chocolate bar: 2.55')
    end
  end

  describe 'constants' do
    it 'defines TAX_RATE as 10%' do
      expect(Product::TAX_RATE).to eq(0.10)
    end

    it 'defines IMPORT_TAX_RATE as 5%' do
      expect(Product::IMPORT_TAX_RATE).to eq(0.05)
    end

    it 'defines EXEMPT_CATEGORIES' do
      expect(Product::EXEMPT_CATEGORIES).to eq(%w[book food medical])
    end
  end

  describe 'private methods' do
    let(:product) { Product.new('item', 10.00, 1, 'other') }

    describe '#exempt?' do
      it 'returns true for book category' do
        product = Product.new('book', 10.00, 1, 'book')

        expect(product.send(:exempt?)).to be true
      end

      it 'returns true for food category' do
        product = Product.new('chocolate', 10.00, 1, 'food')

        expect(product.send(:exempt?)).to be true
      end

      it 'returns true for medical category' do
        product = Product.new('pills', 10.00, 1, 'medical')

        expect(product.send(:exempt?)).to be true
      end

      it 'returns false for other categories' do
        product = Product.new('perfume', 10.00, 1, 'other')

        expect(product.send(:exempt?)).to be false
      end
    end

    describe '#tax_rate' do
      it 'returns 0 for exempt items' do
        product = Product.new('book', 10.00, 1, 'book')

        expect(product.send(:tax_rate)).to eq(0)
      end

      it 'returns TAX_RATE for non-exempt items' do
        product = Product.new('perfume', 10.00, 1, 'other')

        expect(product.send(:tax_rate)).to eq(0.10)
      end
    end

    describe '#import_tax_rate' do
      it 'returns 0 for non-imported items' do
        product = Product.new('book', 10.00, 1, 'book', false)

        expect(product.send(:import_tax_rate)).to eq(0)
      end

      it 'returns IMPORT_TAX_RATE for imported items' do
        product = Product.new('imported book', 10.00, 1, 'book', true)

        expect(product.send(:import_tax_rate)).to eq(0.05)
      end
    end

    describe '#total_tax_rate' do
      it 'returns 0 for non-imported exempt items' do
        product = Product.new('book', 10.00, 1, 'book', false)

        expect(product.send(:total_tax_rate)).to eq(0.0)
      end

      it 'returns 0.05 for imported exempt items' do
        product = Product.new('imported book', 10.00, 1, 'book', true)

        expect(product.send(:total_tax_rate)).to eq(0.05)
      end

      it 'returns 0.10 for non-imported taxable items' do
        product = Product.new('perfume', 10.00, 1, 'other', false)

        expect(product.send(:total_tax_rate)).to eq(0.10)
      end

      it 'returns 0.15 for imported taxable items' do
        product = Product.new('imported perfume', 10.00, 1, 'other', true)

        expect(product.send(:total_tax_rate)).to eq(0.15)
      end
    end
  end
end
