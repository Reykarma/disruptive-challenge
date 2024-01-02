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
    build_cripto_data.each do |cripto|
      begin
        price_cripto = @coin_api.get_price(cripto[:id])
        cripto_balance = cripto_balance(price_cripto, cripto[:amount_invest])
        balance_data = build_balance_data(cripto, price_cripto, cripto_balance)
        investment_data << balance_data
      rescue StandardError => exception
        Rails.logger.error("Error al obtener el precio para #{cripto[:id]}: #{exception.message}")
        raise StandardError, "Error al obtener el precio de la cripto #{cripto[:id]}"
      end
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
    data
  end

  def build_cripto_data
    cripto_data = []
    @csv_data.map do |cripto|
      cripto_object = {
        id: cripto_id(cripto['Moneda'].downcase),
        name: cripto['Moneda'],
        month_percent: cripto['Interes_mensual'],
        amount_invest: cripto['balance_ini']
      }
      cripto_data << cripto_object
    end
    cripto_data
  end

  def cripto_id(name)
    case name
    when 'bitcoin'
      'BTC'
    when 'ether'
      'ETC'
    else
      'ADA'
    end
  end

	def build_balance_data(cripto, price_cripto, cripto_balance)
		{
      name: cripto[:name],
      price_usd: price_cripto,
      cripto_balance: cripto_balance,
      month_return: month_return(cripto_balance, cripto[:month_percent]),
      year_return: year_return(cripto_balance, cripto[:month_percent])
    }
	end

  def cripto_balance(price_cripto, amount_invest)
    amount_invest.to_f / price_cripto
  end

  def month_return(cripto_balance, month_percent)
    result = (month_percent.to_f / 100) * cripto_balance
  end

  def year_return(cripto_balance, month_percent)
    result = ( (month_percent.to_f / 100) * cripto_balance ) * 12
  end
end

