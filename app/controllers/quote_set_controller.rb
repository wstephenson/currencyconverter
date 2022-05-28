class QuoteSetController < ApplicationController
  before_action :set_quote_set, only: [:show, :update, :delete]

  def index
    @quote_sets = QuoteSet.all

    render json: @quote_sets
  end

  def show
    render json: @quote_set
  end

  private
  def set_quote_set
    @quote_set = QuoteSet.find(params[:id])
  end
end
