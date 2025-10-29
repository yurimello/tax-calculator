class ProductBuilder
  def self.build(product_line, file_type = 'txt')
    case file_type
    when 'txt'
      TxtProductBuilder.new.build(product_line)
    else
      raise "File type #{file_type} not supported"  
    end
  end
end