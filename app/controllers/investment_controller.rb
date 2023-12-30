class InvestmentController < ApplicationController
  def balance
    if params[:csv_file].present?
      render json: Investment.calculate_from_csv(params[:csv_file])
    else
      render json: { error: "CSV file not provided" }
    end
  end
end
