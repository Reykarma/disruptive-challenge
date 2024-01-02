require 'rails_helper'

RSpec.describe InvestmentController, type: :controller do
  describe "#balance" do
    context "cuando se proporciona un archivo CSV" do
      let(:csv_file) { fixture_file_upload(file_fixture('test.csv'), 'text/csv') }

      it "responde con el resultado del cálculo" do
        post :balance, params: { csv_file: csv_file }

        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include("result")
      end
    end

    context "cuando no se proporciona un archivo CSV" do
      it "responde con un mensaje de error" do
        post :balance

        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include("error")
        expect(parsed_response["error"]).to eq("CSV file not provided")
      end
    end
  end
end
