class TxtProductBuilder
  PRODUCT_LINE_REGEX = /^(\d*)(.*)at\s*(\d*\.\d*)\s*$/i
  CATEGORY_REGEX = /(book?|chocolate?|pill?|music|perfume)s?/i
  IMPORTED_REGEX = /imported/i

  def self.build(product_line, product_validator = TxtProductValidator)
    raise "Invalid product line: #{product_line}" unless product_validator.validate(product_line, { product_regex: PRODUCT_LINE_REGEX })

    quantity, name, price = product_line.match(PRODUCT_LINE_REGEX).captures
    category = name.match(CATEGORY_REGEX)&.captures&.first
    imported = name.match(IMPORTED_REGEX)
    Product.new(name, price.to_f, quantity.to_i, category, imported)    
  end
end