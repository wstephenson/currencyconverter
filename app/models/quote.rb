class Quote < ApplicationRecord
  belongs_to :quote_set

  class InconvertibleAmount < StandardError; end

  def convert(amount)
    raise InconvertibleAmount unless amount.is_a? BigDecimal
    rate * amount
  end
end
