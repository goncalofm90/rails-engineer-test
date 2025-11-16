require 'csv'

class CsvImporter
  attr_reader :file_path, :result

  def initialize(file_path)
    @file_path = file_path
    @result = { imported: 0, updated: 0, skipped: 0, errors: [] }
  end

  def import
    CSV.foreach(file_path, headers: true, col_sep: ';').with_index(2) do |row, line_number|
      process_row(row, line_number)
    end
    
    result
  rescue CSV::MalformedCSVError => e
    result[:errors] << "CSV error: #{e.message}"
    result
  rescue => e
    result[:errors] << "Error during import: #{e.message}"
    result
  end

  private

  def process_row(row, line_number)
    if row['coc_number'].blank?
      result[:skipped] += 1
      return
    end

    if row['company_name'].blank?
      result[:errors] << "Line #{line_number}: Please specify a company name"
      result[:skipped] += 1
      return
    end

    coc_number = row['coc_number'].strip
    
    company = Company.find_or_initialize_by(coc_number: coc_number)
    
    if company.new_record?
      result[:imported] += 1
    else
      result[:updated] += 1
    end
    
    company.assign_attributes(
      name: row['company_name'].strip,
      city: row['city']&.strip
    )
    
    unless company.save
      result[:errors] << "Line #{line_number}: #{company.errors.full_messages.join(', ')}"
      result[:skipped] += 1
    end
  rescue => e
    result[:errors] << "Line #{line_number}: #{e.message}"
    result[:skipped] += 1
  end
end