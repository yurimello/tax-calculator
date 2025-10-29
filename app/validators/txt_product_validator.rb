class TxtProductValidator < ProductValidator
  def self.validate(product_line, opts)
    product_line.match?(opts[:product_regex])
  end
end