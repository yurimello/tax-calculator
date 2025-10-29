RSpec.describe TxtProductBuilder do
  describe '.build' do
    context 'with valid product lines' do
      it 'builds a basic book product' do
        product_line = '1 book at 12.49'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('book')
        expect(product.net_price).to eq(12.49)
        expect(product.quantity).to eq(1)
        expect(product.category).to eq('book')
        expect(product.imported).to be_falsey
      end

      it 'builds a chocolate product' do
        product_line = '2 box of chocolates at 10.00'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('box of chocolates')
        expect(product.net_price).to eq(10.00)
        expect(product.quantity).to eq(2)
        expect(product.category).to eq('food')
        expect(product.imported).to be_falsey
      end

      it 'builds a music CD product' do
        product_line = '1 music CD at 14.99'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('music CD')
        expect(product.net_price).to eq(14.99)
        expect(product.quantity).to eq(1)
        expect(product.category).to eq('music')
        expect(product.imported).to be_falsey
      end

      it 'builds a perfume product' do
        product_line = '1 bottle of perfume at 18.99'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('bottle of perfume')
        expect(product.net_price).to eq(18.99)
        expect(product.quantity).to eq(1)
        expect(product.category).to eq('perfume')
        expect(product.imported).to be_falsey
      end

      it 'builds a pills product' do
        product_line = '1 packet of headache pills at 9.75'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('packet of headache pills')
        expect(product.net_price).to eq(9.75)
        expect(product.quantity).to eq(1)
        expect(product.category).to eq('medical')
        expect(product.imported).to be_falsey
      end
    end

    context 'with imported products' do
      it 'builds an imported box of chocolates' do
        product_line = '1 imported box of chocolates at 10.00'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('imported box of chocolates')
        expect(product.net_price).to eq(10.00)
        expect(product.quantity).to eq(1)
        expect(product.category).to eq('food')
        expect(product.imported).to be_truthy
      end

      it 'builds an imported bottle of perfume' do
        product_line = '1 imported bottle of perfume at 27.99'

        product = described_class.build(product_line)

        expect(product).to be_a(Product)
        expect(product.name).to eq('imported bottle of perfume')
        expect(product.net_price).to eq(27.99)
        expect(product.quantity).to eq(1)
        expect(product.category).to eq('perfume')
        expect(product.imported).to be_truthy
      end

      it 'detects imported regardless of case' do
        product_line = '1 Imported book at 15.50'

        product = described_class.build(product_line)

        expect(product.imported).to be_truthy
        expect(product.category).to eq('book')
      end
    end

    context 'with various quantities' do
      it 'builds product with zero quantity (empty string)' do
        product_line = ' book at 12.49'

        product = described_class.build(product_line)

        expect(product.quantity).to eq(0)
        expect(product.name).to eq('book')
      end

      it 'builds product with large quantity' do
        product_line = '100 boxes of chocolates at 5.00'

        product = described_class.build(product_line)

        expect(product.quantity).to eq(100)
        expect(product.net_price).to eq(5.00)
      end

      it 'builds product with single digit quantity' do
        product_line = '3 chocolate bar at 0.85'

        product = described_class.build(product_line)

        expect(product.quantity).to eq(3)
        expect(product.net_price).to eq(0.85)
      end
    end

    context 'with various price formats' do
      it 'builds product with decimal price' do
        product_line = '1 book at 12.49'

        product = described_class.build(product_line)

        expect(product.net_price).to eq(12.49)
      end

      it 'builds product with price having trailing zeros' do
        product_line = '1 chocolate at 10.00'

        product = described_class.build(product_line)

        expect(product.net_price).to eq(10.00)
      end

      it 'builds product with price less than 1' do
        product_line = '1 chocolate bar at 0.85'

        product = described_class.build(product_line)

        expect(product.net_price).to eq(0.85)
      end

      it 'builds product with zero price' do
        product_line = '1 free sample at 0.00'

        product = described_class.build(product_line)

        expect(product.net_price).to eq(0.00)
      end

      it 'builds product with no leading zero in decimal' do
        product_line = '1 chocolate bar at .85'

        product = described_class.build(product_line)

        expect(product.net_price).to eq(0.85)
      end
    end

    context 'with category detection' do
      it 'detects singular category forms and maps them' do
        expect(described_class.build('1 book at 10.00').category).to eq('book')
        expect(described_class.build('1 chocolate at 5.00').category).to eq('food')
        expect(described_class.build('1 pill at 3.00').category).to eq('medical')
      end

      it 'detects plural category forms and maps them' do
        expect(described_class.build('1 books at 10.00').category).to eq('book')
        expect(described_class.build('1 chocolates at 5.00').category).to eq('food')
        expect(described_class.build('1 pills at 3.00').category).to eq('medical')
      end

      it 'detects category regardless of case' do
        expect(described_class.build('1 BOOK at 10.00').category).to eq('book')
        expect(described_class.build('1 Book at 10.00').category).to eq('book')
        expect(described_class.build('1 ChOcOlAtE at 5.00').category).to eq('food')
      end

      it 'detects music category' do
        product_line = '1 music CD at 14.99'

        product = described_class.build(product_line)

        expect(product.category).to eq('music')
      end

      it 'detects perfume category' do
        product_line = '1 perfume at 20.00'

        product = described_class.build(product_line)

        expect(product.category).to eq('perfume')
      end

      it 'detects perfumes category' do
        product_line = '1 perfumes at 20.00'

        product = described_class.build(product_line)

        expect(product.category).to eq('perfume')
      end
    end

    context 'with custom validator' do
      let(:mock_validator) { double('Validator') }

      it 'uses the provided validator' do
        product_line = '1 book at 12.49'
        expect(mock_validator).to receive(:validate)
          .with(product_line, { product_regex: TxtProductBuilder::PRODUCT_LINE_REGEX })
          .and_return(true)

        described_class.build(product_line, mock_validator)
      end

      it 'raises error when validator returns false' do
        product_line = 'invalid line'
        expect(mock_validator).to receive(:validate)
          .with(product_line, { product_regex: TxtProductBuilder::PRODUCT_LINE_REGEX })
          .and_return(false)

        expect {
          described_class.build(product_line, mock_validator)
        }.to raise_error(RuntimeError, "Invalid product line: #{product_line}")
      end
    end

    context 'with invalid product lines' do
      it 'raises error for empty string' do
        product_line = ''

        expect {
          described_class.build(product_line)
        }.to raise_error(RuntimeError, 'Invalid product line: ')
      end

      it 'raises error for line without "at" keyword' do
        product_line = '1 book 12.49'

        expect {
          described_class.build(product_line)
        }.to raise_error(RuntimeError, "Invalid product line: #{product_line}")
      end

      it 'raises error for line without price' do
        product_line = '1 book at'

        expect {
          described_class.build(product_line)
        }.to raise_error(RuntimeError, "Invalid product line: #{product_line}")
      end

      it 'raises error for line with invalid price format' do
        product_line = '1 book at 12'

        expect {
          described_class.build(product_line)
        }.to raise_error(RuntimeError, "Invalid product line: #{product_line}")
      end

      it 'raises error for line with text after price' do
        product_line = '1 book at 12.49 each'

        expect {
          described_class.build(product_line)
        }.to raise_error(RuntimeError, "Invalid product line: #{product_line}")
      end
    end

    context 'edge cases' do
      it 'handles product names with multiple spaces (strip removes leading/trailing)' do
        product_line = '1 box  of  chocolates at 10.00'

        product = described_class.build(product_line)

        expect(product.name).to eq('box  of  chocolates')
      end

      it 'handles extra spaces around at keyword' do
        product_line = '1 music CD  at  14.99'

        product = described_class.build(product_line)

        expect(product.net_price).to eq(14.99)
      end

      it 'handles multiple category keywords (first match wins)' do
        product_line = '1 book about chocolates at 15.00'

        product = described_class.build(product_line)

        expect(product.category).to eq('book')
      end

      it 'handles both imported and category keywords' do
        product_line = '1 imported box of chocolates at 11.25'

        product = described_class.build(product_line)

        expect(product.imported).to be_truthy
        expect(product.category).to eq('food')
      end
    end
  end
end
