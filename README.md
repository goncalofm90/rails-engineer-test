# Company Search Application

A Rails web application for searching companies with CSV import functionality. Built as a technical assessment for Beequip.

## Tech Stack

- Ruby on Rails 7.0
- SQLite (development)
- Stimulus.js for interactive features
- Turbo Streams for real-time updates
- Bootstrap 5 for styling

## Setup Instructions

### Prerequisites

- Ruby 3.x
- Rails 7.x
- Bundler

### Installation

1. **Clone the repository**:
```bash
git clone <repository-url>
cd company-search
```

2. **Install dependencies**:
```bash
bundle install
```

> **Note for Mac M4 Users**: The gemfile was updated but if you encounter native extension build errors (particularly with `sqlite3` , `nokogiri` or `nio4r`), update your `Gemfile` to use compatible versions:
>
> ```ruby
> # Use sqlite3 as the database for Active Record
> gem "sqlite3", "~> 1.7"
> 
> # For nokogiri compatibility on ARM Macs
> gem "nokogiri", "~> 1.15"
> # For nio4r
> gem "nio4r (~> 2.0)"
>
> ```
>
> Then run:
> ```bash
> bundle update sqlite3 nokogiri
> ```

3. **Setup database**:
```bash
rails db:create
rails db:migrate
```

4. **Verify schema**:
Check that `db/schema.rb` exists and contains the expression indexes for case-insensitive search.

5. **Start the server**:
```bash
rails server
```

6. **Access the application**:
- Search page: http://localhost:3000
- Admin import: http://localhost:3000/admin/imports/new

## Usage

### Importing Companies

1. Navigate to http://localhost:3000/admin/imports/new
2. Upload a CSV file with the following format:
   ```
   coc_number;company_name;city
   12345678;Example Company BV;Amsterdam
   87654321;Another Corp;Rotterdam
   ```

### Validation Rules

- CoC number is required (rows with blank CoC numbers are skipped)
- Company name is required
- Duplicate CoC numbers: last entry in the file wins
- Invalid rows are reported with line numbers

### Searching Companies

1. Navigate to http://localhost:3000
2. Start typing in the search field
3. Results appear progressively as you type
4. Search works across:
   - Company name
   - City
   - CoC number (Chamber of Commerce number)


### Models

**Company** (`app/models/company.rb`)
- Core business entity
- Validations for required fields
- Case-insensitive search method using SQL LOWER()

### Controllers

**CompaniesController** (`app/controllers/companies_controller.rb`)
- Handles search requests
- Returns Turbo Stream responses for progressive search

**Admin::ImportsController** (`app/controllers/admin/imports_controller.rb`)
- Manages CSV upload and import
- Coordinates validation and import services

### Service Objects

**CsvValidator** (`app/services/csv_validator.rb`)
- Validates file format, size, and structure
- Checks for required headers
- Ensures file is not empty or malformed

**CsvImporter** (`app/services/csv_importer.rb`)
- Handles the actual import logic
- Provides detailed error reporting per row
- Tracks imported, updated, and skipped records

### Database Schema

```ruby
create_table "companies" do |t|
  t.string "coc_number", null: false
  t.string "name", null: false
  t.string "city"
  t.string "address"
  t.string "postal_code"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
end

# Indexes
add_index "companies", "coc_number", unique: true
add_index "companies", "LOWER(name)"
add_index "companies", "LOWER(city)"
add_index "companies", "LOWER(coc_number)"
```

## Performance Optimizations

### Expression Indexes

The application uses expression indexes for optimal case-insensitive search:

- `LOWER(name)` - For company name searches
- `LOWER(city)` - For city searches  
- `LOWER(coc_number)` - For CoC number searches

These indexes ensure fast LIKE queries without case-sensitivity issues across different database systems (SQLite, PostgreSQL, MySQL).