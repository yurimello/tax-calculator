# Tax Calculator

A Ruby application that calculates sales tax and total prices for shopping cart items. The application handles basic sales tax, import duties, and tax-exempt categories according to specific rounding rules.

## Project Kanban
[Board](https://github.com/users/yurimello/projects/5)

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Tax Rules](#tax-rules)
- [Running Tests](#running-tests)
- [Implementation Details](#implementation-details)

## Features

- **Sales Tax Calculation**: Applies 10% basic sales tax on applicable items
- **Import Duty**: Applies 5% import tax on imported goods
- **Tax Exemptions**: Books, food, and medical products are exempt from basic sales tax
- **Special Rounding**: Tax amounts are rounded UP to the nearest 0.05
- **CLI Interface**: Simple command-line interface for processing shopping carts
- **Flexible Input**: Reads product data from text files

## Installation

### Prerequisites
- Ruby 3.2.2 or higher
- Bundler

### Setup
```bash
# Clone the repository
git clone https://github.com/yurimello/tax-calculator.git
cd tax-calculator

# Install dependencies
bundle install
```

## Usage

### Basic Usage

Run the tax calculator with an input file:

```bash
ruby bin/tax_calculator.rb -f spec/fixtures/input_1.txt
```

Or using the long form:

```bash
ruby bin/tax_calculator.rb --file spec/fixtures/input_1.txt
```

### Get Help

```bash
ruby bin/tax_calculator.rb -h
```

### Input File Format

Input files should contain one product per line in the format:

```
[quantity] [product name] at [price]
```

**Examples:**
```
1 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50
```

**Keywords:**
- `imported` - marks the product as imported (case-insensitive)
- `book/books` - tax-exempt category
- `chocolate/chocolates` - tax-exempt category (food)
- `pill/pills` - tax-exempt category (medical)
- `music` - taxable category
- `perfume/perfumes` - taxable category

## Tax Rules

### Basic Sales Tax
- **Rate**: 10%
- **Applied to**: All items except books, food, and medical products
- **Exempt Categories**:
  - Books
  - Food (chocolate)
  - Medical products (pills)

### Import Duty
- **Rate**: 5%
- **Applied to**: All imported items (including tax-exempt categories)

### Tax Calculation & Rounding

The application uses a special rounding rule:

> **"For a tax rate of n%, a shelf price of p contains (np/100 rounded UP to the nearest 0.05) amount of sales tax."**

**Key Points:**
1. Calculate raw tax: `price × tax_rate`
2. Round **UP** (not standard rounding) to nearest 0.05
3. Tax is calculated **per item**, then multiplied by quantity

**Why calculate tax per item?**

This is a critical requirement that affects the final price when buying multiple quantities. Due to the rounding rule, calculating tax per item produces different results than calculating on the total.

**Rounding Algorithm:**
```ruby
def round_up_to_nearest_005(amount)
  (amount * 20).ceil / 20.0
end
```

**Why multiply by 20?**

The number 20 comes from the mathematical relationship: **0.05 = 1/20**

By multiplying by 20, we convert the problem from "round to nearest 0.05" into "round to nearest integer"


## Running Tests

The project uses RSpec for testing.

### Run All Tests
```bash
bundle exec rspec
```

## Implementation Details

### Key Classes

#### Product
- Stores product details (name, price, quantity, category, imported status)
- Calculates tax based on category and import status
- Implements special rounding rule for tax amounts

#### Cart
- Contains collection of products
- Calculates total sales tax and grand total

#### TxtProductBuilder
- Parses text lines using regex patterns
- Maps categories (e.g., chocolate → food, pill → medical)
- Detects imported products

#### CartImporterService
- Reads files and processes each line
- Uses appropriate builder based on file type
- Returns populated cart

#### PrintCartService
- Formats output with proper decimal places
- Displays products, sales taxes, and total

### Design Patterns

- **Builder Pattern**: `TxtProductBuilder` for constructing products from text
- **Service Pattern**: Services handle business logic and orchestration
- **Validator Pattern**: Input validation separated from business logic
