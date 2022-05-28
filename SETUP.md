bundle exec jets new currency-converter --mode api --database postgresql

bundle config set --local local.money-apilayer_currencydata-bank /home/will/code/ruby/currencylayer/money-apilayer_currencydata-bank

## Local dev setup only ##
export DB_PASS=converter DB_USER=cc DB_HOST=localhost
