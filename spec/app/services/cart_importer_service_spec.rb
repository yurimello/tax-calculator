RSpec.describe CartImporterService do
  describe '.call' do
    it 'creates a new instance and calls it' do
      file_path = 'path/to/file.txt'
      file_type = 'txt'
      service_instance = instance_double(CartImporterService)

      allow(described_class).to receive(:new).with(file_path, file_type).and_return(service_instance)
      allow(service_instance).to receive(:call)

      described_class.call(file_path, file_type)

      expect(described_class).to have_received(:new).with(file_path, file_type)
      expect(service_instance).to have_received(:call)
    end

    it 'defaults to txt file type when not specified' do
      file_path = 'path/to/file.txt'
      service_instance = instance_double(CartImporterService)

      allow(described_class).to receive(:new).with(file_path, 'txt').and_return(service_instance)
      allow(service_instance).to receive(:call)

      described_class.call(file_path)

      expect(described_class).to have_received(:new).with(file_path, 'txt')
    end
  end

  describe '#initialize' do
    it 'sets the file path and file type' do
      file_path = 'path/to/file.txt'
      file_type = 'txt'

      service = described_class.new(file_path, file_type)

      expect(service.instance_variable_get(:@file_path)).to eq(file_path)
      expect(service.instance_variable_get(:@file_type)).to eq(file_type)
    end

    it 'initializes a new cart' do
      file_path = 'path/to/file.txt'
      file_type = 'txt'
      cart_double = instance_double(Cart)

      allow(Cart).to receive(:new).and_return(cart_double)

      service = described_class.new(file_path, file_type)

      expect(Cart).to have_received(:new)
      expect(service.instance_variable_get(:@cart)).to eq(cart_double)
    end
  end

  describe '#call' do
    let(:file_path) { 'spec/fixtures/test_input.txt' }
    let(:file_type) { 'txt' }
    let(:service) { described_class.new(file_path, file_type) }
    let(:product_builder_double) { double('ProductBuilder') }
    let(:product1_double) { instance_double(Product) }
    let(:product2_double) { instance_double(Product) }
    let(:product3_double) { instance_double(Product) }

    before do
      allow(File).to receive(:read).with(file_path).and_return(file_content)
      allow(service).to receive(:product_builder).and_return(product_builder_double)
    end

    context 'with multiple product lines' do
      let(:file_content) do
        "2 book at 12.49\n1 music CD at 14.99\n1 chocolate bar at 0.85"
      end

      it 'reads the file and splits by newline' do
        allow(product_builder_double).to receive(:build).and_return(product1_double)

        service.call

        expect(File).to have_received(:read).with(file_path)
      end

      it 'builds a product for each line' do
        allow(product_builder_double).to receive(:build).with('2 book at 12.49').and_return(product1_double)
        allow(product_builder_double).to receive(:build).with('1 music CD at 14.99').and_return(product2_double)
        allow(product_builder_double).to receive(:build).with('1 chocolate bar at 0.85').and_return(product3_double)

        service.call

        expect(product_builder_double).to have_received(:build).with('2 book at 12.49')
        expect(product_builder_double).to have_received(:build).with('1 music CD at 14.99')
        expect(product_builder_double).to have_received(:build).with('1 chocolate bar at 0.85')
      end

      it 'adds each product to the cart' do
        allow(product_builder_double).to receive(:build).with('2 book at 12.49').and_return(product1_double)
        allow(product_builder_double).to receive(:build).with('1 music CD at 14.99').and_return(product2_double)
        allow(product_builder_double).to receive(:build).with('1 chocolate bar at 0.85').and_return(product3_double)

        service.call

        cart = service.instance_variable_get(:@cart)
        expect(cart.products).to include(product1_double)
        expect(cart.products).to include(product2_double)
        expect(cart.products).to include(product3_double)
        expect(cart.products.size).to eq(3)
      end
    end

    context 'with single product line' do
      let(:file_content) { '1 book at 12.49' }

      it 'builds and adds one product' do
        allow(product_builder_double).to receive(:build).with('1 book at 12.49').and_return(product1_double)

        service.call

        expect(product_builder_double).to have_received(:build).with('1 book at 12.49')
        cart = service.instance_variable_get(:@cart)
        expect(cart.products).to include(product1_double)
        expect(cart.products.size).to eq(1)
      end
    end

    context 'with empty file' do
      let(:file_content) { '' }

      it 'handles empty file without errors' do
        service.call

        cart = service.instance_variable_get(:@cart)
        expect(cart.products).to be_empty
      end
    end

    context 'with file containing only newlines' do
      let(:file_content) { "\n\n\n" }

      it 'handles file with only newlines without building products' do
        service.call

        # split("\n") on "\n\n\n" produces [] in Ruby
        cart = service.instance_variable_get(:@cart)
        expect(cart.products).to be_empty
      end
    end

    context 'with imported products' do
      let(:file_content) do
        "1 imported box of chocolates at 10.00\n1 imported bottle of perfume at 47.50"
      end

      it 'builds imported products correctly' do
        allow(product_builder_double).to receive(:build).with('1 imported box of chocolates at 10.00').and_return(product1_double)
        allow(product_builder_double).to receive(:build).with('1 imported bottle of perfume at 47.50').and_return(product2_double)

        service.call

        expect(product_builder_double).to have_received(:build).with('1 imported box of chocolates at 10.00')
        expect(product_builder_double).to have_received(:build).with('1 imported bottle of perfume at 47.50')
        cart = service.instance_variable_get(:@cart)
        expect(cart.products.size).to eq(2)
      end
    end
  end

  describe '#product_builder' do
    context 'when file type is txt' do
      it 'returns the TxtProductBuilder class' do
        service = described_class.new('path/to/file.txt', 'txt')

        builder = service.product_builder

        expect(builder).to eq(TxtProductBuilder)
      end
    end

    context 'when file type is not supported' do
      it 'raises an error for csv file type' do
        service = described_class.new('path/to/file.csv', 'csv')

        expect {
          service.product_builder
        }.to raise_error(RuntimeError, 'File type not supported')
      end

      it 'raises an error for json file type' do
        service = described_class.new('path/to/file.json', 'json')

        expect {
          service.product_builder
        }.to raise_error(RuntimeError, 'File type not supported')
      end

      it 'raises an error for xml file type' do
        service = described_class.new('path/to/file.xml', 'xml')

        expect {
          service.product_builder
        }.to raise_error(RuntimeError, 'File type not supported')
      end
    end
  end

  describe 'integration with real file' do
    let(:file_path) { 'spec/fixtures/input_1.txt' }
    let(:file_type) { 'txt' }
    let(:service) { described_class.new(file_path, file_type) }
    let(:product_builder_double) { double('ProductBuilder') }
    let(:product1_double) { instance_double(Product) }
    let(:product2_double) { instance_double(Product) }
    let(:product3_double) { instance_double(Product) }

    before do
      allow(service).to receive(:product_builder).and_return(product_builder_double)
      allow(product_builder_double).to receive(:build).with('2 book at 12.49').and_return(product1_double)
      allow(product_builder_double).to receive(:build).with('1 music CD at 14.99').and_return(product2_double)
      allow(product_builder_double).to receive(:build).with('1 chocolate bar at 0.85').and_return(product3_double)
    end

    it 'processes the real fixture file' do
      service.call

      cart = service.instance_variable_get(:@cart)
      expect(cart.products.size).to eq(3)
      expect(cart.products).to include(product1_double, product2_double, product3_double)
    end
  end

  describe 'error handling' do
    let(:file_path) { 'path/to/file.txt' }
    let(:file_type) { 'txt' }
    let(:service) { described_class.new(file_path, file_type) }

    context 'when file does not exist' do
      it 'raises an error' do
        allow(File).to receive(:read).with(file_path).and_raise(Errno::ENOENT)

        expect {
          service.call
        }.to raise_error(Errno::ENOENT)
      end
    end

    context 'when file is not readable' do
      it 'raises an error' do
        allow(File).to receive(:read).with(file_path).and_raise(Errno::EACCES)

        expect {
          service.call
        }.to raise_error(Errno::EACCES)
      end
    end

    context 'when product builder raises an error' do
      let(:product_builder_double) { double('ProductBuilder') }

      before do
        allow(File).to receive(:read).with(file_path).and_return('invalid line')
        allow(service).to receive(:product_builder).and_return(product_builder_double)
      end

      it 'propagates the error' do
        allow(product_builder_double).to receive(:build).and_raise(RuntimeError, 'Invalid product line')

        expect {
          service.call
        }.to raise_error(RuntimeError, 'Invalid product line')
      end
    end
  end
end
