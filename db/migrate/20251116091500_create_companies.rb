class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :coc_number, null: false
      t.string :name, null: false
      t.string :city
      t.string :address
      t.string :postal_code

      t.timestamps
    end

    add_index :companies, :coc_number, unique: true
    add_index :companies, :name
    add_index :companies, :city
  end
end