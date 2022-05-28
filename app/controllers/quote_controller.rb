class QuoteController < ApplicationController
  before_action :set_quote, only: [:show, :update, :delete]

  def index
    @quotes = Quote.all

    render json: @quotes
  end

  def show
    render json: @quote
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = Quote.find(params[:id])
  end
end
