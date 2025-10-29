class CartImporterService
  
  def self.call(file_path, file_type = 'txt')
    new(file_path, file_type).call
  end

  def initialize(file_path, file_type)
    @file_path = file_path
    @file_type = file_type
    @cart = Cart.new
  end

  def call
    File.read(@file_path).split("\n").map do |line|
      product = product_builder.build(line)
      @cart.products << product
    end
  end

  def product_builder
    case @file_type
    when 'txt'
      TxtProductBuilder.new
    else 
      raise "File type not supported"
    end
  end

end