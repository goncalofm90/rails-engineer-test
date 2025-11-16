module Admin
  class ImportsController < ApplicationController
    def new
    end

    def create
      unless params[:csv_file].present?
        flash[:alert] = "Please select a CSV file to upload."
        render :new, status: :unprocessable_entity
        return
      end

      file = params[:csv_file]
      validator = CsvValidator.new(file)

      unless validator.valid?
        flash[:alert] = "File validation failed: #{validator.errors.join(', ')}"
        render :new, status: :unprocessable_entity
        return
      end

      importer = CsvImporter.new(file.path)
      result = importer.import

      if result[:errors].any?
        flash[:alert] = "Import completed with errors: #{result[:errors].first(3).join('; ')}"
        flash[:notice] = build_success_message(result) if result[:imported] > 0 || result[:updated] > 0
      else
        flash[:notice] = build_success_message(result)
      end

      redirect_to new_admin_import_path

    rescue => e
      flash[:alert] = "Unexpected error during import: #{e.message}"
      render :new, status: :unprocessable_entity
    end

    private

    def build_success_message(result)
      parts = []
      parts << "Imported #{result[:imported]} companies" if result[:imported] > 0
      parts << "updated #{result[:updated]} companies" if result[:updated] > 0
      if result[:skipped] > 0
        row_word = result[:skipped] == 1 ? "row" : "rows"
        parts << "skipped #{result[:skipped]} #{row_word}"
      end
      
      "Successfully " + parts.join(', ') + "."
    end
  end
end