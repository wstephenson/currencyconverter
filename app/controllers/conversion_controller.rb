class ConversionController < ApplicationController
  def convert
    dummy_rate = BigDecimal("1.5")

    # do the conversion here
    render json: (BigDecimal(convert_params['amount']) * dummy_rate).to_s('F')
  end

  private

  def convert_params
    params.permit([:amount, :source, :currency])
  end
end
