#require 'rspec'

describe ConversionController, :type => :controller do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe '#convert' do
    before { post '/convert', body: parms, headers: {"Content-Type": "application/json"} }
    let(:parms) { JSON.generate(amount: '100.0', source: 'USD', currency: 'EUR') }

    it 'responds with json' do

      # Jets' spec helper response is not as clever as rspec-rails'
      expect(response.headers['Content-Type']).to eq 'application/json'
    end

    it 'returns a string that can be converted to a float' do
      expect{ Float(response.body) }.not_to raise_error
    end
  end
end
