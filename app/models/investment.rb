# app/models/investment.rb
class Investment < ApplicationRecord
  def self.calculate_from_csv(csv_file)
    new(csv_file).calculate_investment
  end

  def initialize(csv_file)
    @csv_data = read_csv(csv_file)
    @coin_api = CoinApi.new
  end

  def calculate_investment
    investment_data = []
    cripto_data.each do |cripto|
      price_cripto = @coin_api.get_price(cripto[:id])
      cripto_balance = cripto_balance(price_cripto, cripto[:amount_invest])
			balance_data = build_balance_data(cripto, price_cripto, cripto_balance)
      investment_data << balance_data
    end
    investment_data
  end

  private

	def read_csv(csv_file)
    require 'csv'
    csv_data = csv_file.read
    data = []
    CSV.parse(csv_data, headers: true) do |row|
      data << row.to_hash
    end
    data[0]
  end

  def cripto_data
    [
      { id: 'BTC', name: "Bitcoin", anual_percent: 5, amount_invest: amount_invest(@csv_data['porcentaje_bitcoin']) },
      { id: 'ETH', name: "Ethereum", anual_percent: 4.2, amount_invest: amount_invest(@csv_data['porcentaje_ether']) },
      { id: 'ADA', name: "Cardano", anual_percent: 1, amount_invest: amount_invest(@csv_data['porcentaje_cardano']) }
    ]
  end

	def build_balance_data(cripto, price_cripto, cripto_balance)
		{
      name: cripto[:name],
      price_usd: price_cripto,
      cripto_balance: cripto_balance,
      month_return: month_return(cripto_balance, cripto[:anual_percent]),
      year_return: year_return(cripto_balance, cripto[:anual_percent])
    }
	end

  def amount_invest(investment_percent)
    @csv_data['inversion_dolares'].to_f * (investment_percent.to_f / 100)
  end

  def cripto_balance(price_cripto, amount_invest)
    amount_invest.to_f / price_cripto
  end

  def month_return(cripto_balance, anual_percent)
    result = ((anual_percent.to_f / 100) / 12) * cripto_balance
  end

  def year_return(cripto_balance, anual_percent)
    result = (anual_percent.to_f / 100) * cripto_balance
  end

end

