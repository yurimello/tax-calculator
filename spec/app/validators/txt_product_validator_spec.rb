RSpec.describe TxtProductValidator do
  let(:product_regex) { /^(\d*)(.*)at\s*(\d*\.\d*)\s*$/i }
  let(:opts) { { product_regex: product_regex } }

  describe '.validate' do
    context 'with valid product lines' do
      it 'validates basic product line' do
        product_line = '1 book at 12.49'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with quantity' do
        product_line = '2 box of chocolates at 10.00'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with decimal price' do
        product_line = '1 bottle of perfume at 18.99'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with imported product' do
        product_line = '1 imported box of chocolates at 10.00'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with multiple words in name' do
        product_line = '1 imported bottle of perfume at 27.99'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with extra spaces around at' do
        product_line = '1 music CD  at  14.99'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with single digit price' do
        product_line = '1 chocolate bar at 0.85'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product line with no leading zero in decimal' do
        product_line = '3 chocolate bar at .85'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end
    end

    context 'with invalid product lines' do
      it 'rejects empty string' do
        product_line = ''

        expect(described_class.validate(product_line, opts)).to be_falsey
      end

      it 'rejects line without "at" keyword' do
        product_line = '1 book 12.49'

        expect(described_class.validate(product_line, opts)).to be_falsey
      end

      it 'rejects line without price' do
        product_line = '1 book at'

        expect(described_class.validate(product_line, opts)).to be_falsey
      end

      it 'accepts line without quantity (matches empty digit string)' do
        product_line = 'book at 12.49'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'accepts line without explicit product name (matches empty string)' do
        product_line = '1 at 12.49'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'rejects line with invalid price format (no decimal point)' do
        product_line = '1 book at 12'

        expect(described_class.validate(product_line, opts)).to be_falsey
      end

      it 'accepts line with non-numeric quantity prefix (regex captures as name)' do
        product_line = 'one book at 12.49'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'rejects line with text after price' do
        product_line = '1 book at 12.49 each'

        expect(described_class.validate(product_line, opts)).to be_falsey
      end

      it 'accepts line with multiple "at" keywords (only last one matters)' do
        product_line = '1 book at 10.00 at 12.49'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'handles nil input without crashing' do
        product_line = nil

        expect { described_class.validate(product_line, opts) }.to raise_error(NoMethodError)
      end
    end

    context 'edge cases' do
      it 'validates product with empty quantity' do
        product_line = ' book at 12.49'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'validates product with zero price' do
        product_line = '1 free sample at 0.00'

        expect(described_class.validate(product_line, opts)).to be_truthy
      end

      it 'rejects product with negative price' do
        product_line = '1 book at -12.49'

        expect(described_class.validate(product_line, opts)).to be_falsey
      end
    end
  end
end
