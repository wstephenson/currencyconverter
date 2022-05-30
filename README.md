# Currency Conversion Project

This is a learning project to investigate creating Ruby applications that use AWS Lambda

It uses [Ruby on Jets](https://rubyonjets.com), a Rails-inspired framework to make the repetitive stuff about deploying to AWS easy.

It uses the Money::CurrencyLayer::Bank gem (`money-currencylayer-bank`) to fetch forex rates from an API, store them in its database, and expose those rates and a /convert endpoint to perform conversions between cached rates.

## CAVEAT ##

The [currencylayer.com](currencylayer.com) service is no longer accepting new signups, and redirects signup requests to apilayer.com.  For this reason I have adapted the above gem to use the equivalent apilayer.com API, forked and renamed it to: https://github.com/wstephenson/money-apilayer_currencydata-bank.

This also has the advantage that non-USD source currency rates are accessible using a free account, so conversion is possible using published rates, rather than computing inverse rates or non USD rates from the rates to the USD base currency.  The gem uses floating point math for this, which can introduce rounding errors, and does not account that the published inverse rate (eg EURUSD) may be different to a calculated inverse rate derived from 1.0/USDEUR.

## CONFIGURATION ##

Configuration is via the DB_HOST, DB_USER, DB_PASS environment variables (postgres db), and MCLB_API_KEY, which should contain a key for an /apilayer.com/ account, which is subscribed to the currency_data API!


## RUNNING ##
The application can be started in a local sandbox with s/rails/jets commands:

```
 > export DB_PASS=<your-db-password> DB_USER=<your-db-user-with-createdb> DB_HOST=localhost MCLB_API_KEY=<your-apilayer-currencydata-key-goes-here>
 > bundle
 > bundle exec jets db:create :db:migrate
 > bundle exec jets server
```

Quotes can be fetched from the remote API with a job:

```
 > bundle exec jets console
 > UpdateQuotesJob.perform_now(:fetch, {})
```

Quotes are stored under a QuoteSet model, both are accessible via endpoints `/quotes` and `/quote_sets`.

A `/convert` endpoint provides conversion using the most recent stored rate:

```
 > curl -i -X POST http://localhost:8888/convert -H 'Content-Type: application/json' --data '{"amount": "100,000", "source_currency": "EUR", "destination_currency": "CHF"}'
{"amount":"102.8311","rate":"1.028311","timestamp":"2022-05-28T15:54:04.000Z"}
```

A sample test suite is present using rspec:

```
 > bundle exec rspec
```
