require 'csv'

class CsvValidator
  REQUIRED_HEADERS = %w[coc_number company_name city].freeze
  MAX_FILE_SIZE = 50.megabytes
  ALLOWED_CONTENT_TYPE = 'text/csv'
  
  attr_reader :file, :errors

  def initialize(file)
    @file = file
    @errors = []
  end

  def valid?
    validate_file_presence
    return false if errors.any?

    validate_file_size
    validate_content_type
    validate_file_not_empty
    validate_csv_structure
    
    errors.empty?
  end

  private

  def validate_file_presence
    errors << "No file provided" if file.nil?
  end

  def validate_file_size
    if file.size > MAX_FILE_SIZE
      errors << "File size exceeds maximum allowed (#{MAX_FILE_SIZE / 1.megabyte}MB)"
    end
  end

  def validate_content_type
    content_type = file.content_type
    unless content_type == ALLOWED_CONTENT_TYPE || 
           content_type == 'application/vnd.ms-excel' ||
           file.original_filename.end_with?('.csv')
      errors << "Invalid file type. Please upload a CSV file"
    end
  end

  def validate_file_not_empty
    if file.size.zero?
      errors << "File is empty"
    end
  end

  def validate_csv_structure
    begin
      csv = CSV.read(file.path, headers: true, col_sep: ';')
      
      if csv.headers.nil? || csv.headers.empty?
        errors << "CSV file has no headers"
        return
      end

      missing_headers = REQUIRED_HEADERS - csv.headers.map(&:to_s)
      if missing_headers.any?
        errors << "CSV is missing headers: #{missing_headers.join(', ')}"
      end

      if csv.empty?
        errors << "CSV file has no rows"
      end
    rescue CSV::MalformedCSVError => e
      errors << "Invalid format: #{e.message}"
    rescue => e
      errors << "Error reading file: #{e.message}"
    end
  end
end