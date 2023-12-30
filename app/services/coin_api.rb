class CoinApi
	def initialize
		@url = 'https://rest.coinapi.io/v1/assets/'
		@api_key = '74AB2CC3-D183-47F8-A3B9-90DB525F1D4B'
	end

	def get_price(cripto_id)
		require 'uri'
		require 'net/http'

		url = URI(@url+cripto_id)
		http = Net::HTTP.new(url.host, url.port)
		request = Net::HTTP::Get.new(url)
		http.use_ssl = true
		request["X-CoinAPI-Key"] = @api_key
		response = http.request(request)
		json_response = JSON.parse(response.read_body)
		json_response[0]['price_usd']
	end
end