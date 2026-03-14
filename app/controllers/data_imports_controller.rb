class DataImportsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    if params[:file].present?
      begin
        file_content = params[:file].read
        data = JSON.parse(file_content)
        DataImportService.new(current_user, data).call
        redirect_to root_path, notice: t("data_imports.create.success")
      rescue JSON::ParserError
        flash.now[:alert] = t("data_imports.create.invalid_json")
        render :new, status: :unprocessable_entity
      rescue => e
        flash.now[:alert] = t("data_imports.create.error", message: e.message)
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = t("data_imports.create.no_file")
      render :new, status: :unprocessable_entity
    end
  end
end
