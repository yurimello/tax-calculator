class TxtProductBuilder
  PRODUCT_LINE_REGEX = /^(\d*)(.*)at\s*(\d*\.\d*)\s*$/i
  CATEGORY_REGEX = /(book|chocolate|pill|music|perfume)s?/i
  IMPORTED_REGEX = /imported/i
  CATEGORIES = {
    'book' => 'book',
    'chocolate' => 'food',
    'pill' => 'medical',
    'music' => 'music',
    'perfume' =>'perfume'
  }

  def self.build(product_line, product_validator = TxtProductValidator)
    raise "Invalid product line: #{product_line}" unless product_validator.validate(product_line, { product_regex: PRODUCT_LINE_REGEX })

    quantity, name, price = product_line.match(PRODUCT_LINE_REGEX).captures
    category_type = name.match(CATEGORY_REGEX)&.captures&.first
    category = CATEGORIES[category_type&.downcase]
    imported = name.match(IMPORTED_REGEX)

    Product.new(name.strip, price.to_f, quantity.to_i, category, imported)
  end
end