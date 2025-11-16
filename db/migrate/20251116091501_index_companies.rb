class IndexCompanies < ActiveRecord::Migration[7.0]
  def up
    # Remove old indexes
    remove_index :companies, :name if index_exists?(:companies, :name)
    remove_index :companies, :city if index_exists?(:companies, :city)
    
    # Add new indexes
    add_index :companies, "LOWER(name)", name: "index_companies_on_lower_name"
    add_index :companies, "LOWER(city)", name: "index_companies_on_lower_city"
    add_index :companies, "LOWER(coc_number)", name: "index_companies_on_lower_coc_number"
  end

  def down
    # revert
    remove_index :companies, name: "index_companies_on_lower_name" if index_exists?(:companies, name: "index_companies_on_lower_name")
    remove_index :companies, name: "index_companies_on_lower_city" if index_exists?(:companies, name: "index_companies_on_lower_city")
    remove_index :companies, name: "index_companies_on_lower_coc_number" if index_exists?(:companies, name: "index_companies_on_lower_coc_number")
    
    add_index :companies, :name
    add_index :companies, :city
  end
end