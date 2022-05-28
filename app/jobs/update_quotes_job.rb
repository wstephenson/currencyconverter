require 'money/bank/apilayer_currencydata_bank'

class UpdateQuotesJob < ApplicationJob
  # Let Jets schedule this job every day at 0645 UTC, so that the latest rates are known at 0800 CET
  # (customer requirement)
  cron "45 6 * * ? *"
  def fetch
    mclb = Money::Bank::ApilayerCurrencyBank.new
    mclb.access_key = ENV['MCLB_API_KEY']
    mclb.secure_connection = false

    mclb.source = 'EUR'

    # The gem usually uses a file cache. This is not possible on AWS Lambda, but the gem
    # helpfully provides a way to avoid touching the filesystem
    mclb.cache = Proc.new do |v|
      key = 'money:apilayer_currencybank'
      if v
        Thread.current[key] = v
      else
        Thread.current[key]
      end
    end

    # Force update
    mclb.update_rates(true)

    # Lambda functions are not persistent, so the gem's (in-memory) cache should never be hot,
    # but just in case, ensure that we are working with live rates, not cached ones
    mclb.ttl_in_seconds = 60

    results = mclb.rates

    ActiveRecord::Base.transaction do
      qs = QuoteSet.create(timestamp: mclb.rates_timestamp, source: mclb.source)

      mclb.rates.each do |k, v|
        Quote.create(currencies: k, rate: v, quote_set: qs)
      end
    end
  end
end
