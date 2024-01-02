# spec/models/investment_spec.rb
require 'rails_helper'

RSpec.describe Investment, type: :model do
  describe '#calculate_investment' do
    it 'calculates investment data' do
      allow_any_instance_of(CoinApi).to receive(:get_price).and_return(50000)

      csv_file =  fixture_file_upload(file_fixture('test.csv'), 'text/csv')

      investment = Investment.new(csv_file)

      result = investment.calculate_investment

      expect(result).to be_an(Array)
      expect(result.size).to eq(3)
    end
  end
end
