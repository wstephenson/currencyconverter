class ConversionController < ApplicationController
  def convert
    most_recent_quoteset = QuoteSet.order(:timestamp).last!

    rate_code = "#{convert_params['source_currency']}#{convert_params['destination_currency']}"

    quote = most_recent_quoteset.quotes.find_by!(currencies: rate_code)

    render json: quote.convert(BigDecimal(convert_params['amount'])).to_s('F')
  rescue ActiveRecord::RecordNotFound
    render json:{ error: "rate for currency pair '#{rate_code}' not found", status: :unprocessable_entity}
  rescue Quote::InconvertibleAmount, ArgumentError
    render json:{ error: "amount '#{convert_params['amount']}' doesn't look like a currency amount", status: :unprocessable_entity}

  end

  private

  def convert_params
    params.permit([:amount, :source_currency, :destination_currency])
  end
end
