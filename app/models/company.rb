class Company < ApplicationRecord
  validates :coc_number, presence: true, uniqueness: true
  validates :name, presence: true

  def self.search(query)
    return none if query.blank?

    sanitized_query = "%#{sanitize_sql_like(query.downcase)}%"
    
    where(
      "LOWER(name) LIKE ? OR LOWER(city) LIKE ? OR LOWER(coc_number) LIKE ?",
      sanitized_query, sanitized_query, sanitized_query
    ).order(:name)
  end
end