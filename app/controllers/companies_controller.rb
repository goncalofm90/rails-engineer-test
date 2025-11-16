class CompaniesController < ApplicationController
  def index
    @companies = if params[:query].present?
      Company.search(params[:query])
    else
      Company.none
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end