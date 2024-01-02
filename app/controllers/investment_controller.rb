class InvestmentController < ApplicationController
  def balance
    if params[:csv_file].present? && params[:csv_file].content_type == 'text/csv'
      begin
        data = Investment.calculate_from_csv(params[:csv_file])
        render json: { result: data }
      rescue StandardError => e
        Rails.logger.error("Error en InvestmentController#balance: #{e.message}")
        render json: { error: "Error al procesar la solicitud" }, status: :internal_server_error
      end
    else
      render json: { error: "CSV file not provided" }
    end
  end
end
