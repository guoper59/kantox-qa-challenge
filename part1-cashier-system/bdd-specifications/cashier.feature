# language: en

@cashier
Feature: Cashier system with discount rules
  As a cashier system user
  I want to add products to the cart and automatically apply discounts
  To correctly calculate the total price to pay

  Background:
    Given the system has the following products loaded:
      | Code | Name         | Price |
      | GR1  | Green Tea    | 3.11  |
      | SR1  | Strawberries | 5.00  |
      | CF1  | Coffee       | 11.23 |
    And the system has the following discount rules:
      | Product | Rule Type         | Parameters                           | Implementation Details        |
      | GR1     | FreeRule          | Buy 1, get 1 free                    | N=1, M=1 (BOGO)              |
      | SR1     | ReducedPriceRule  | Buy 3 or more, pay £4.50 per unit    | N=3, X=4.50                  |
      | CF1     | FractionPriceRule | Buy 3 or more, pay 2/3 of the price  | N=3, X=66.67%, Rounded=7.49  |

  # Base Cart Operations
  @cart @basic
  Scenario: Empty cart total price
    Given the cart is empty
    When the total price is calculated
    Then the total price should be £0.00

  @cart @basic
  Scenario: Add single item to cart (Green Tea)
    When I add 1 unit of "Green Tea" to the cart
    Then the cart should contain 1 product
    And the total price should be £3.11

  @cart @basic
  Scenario: Add single item to cart (Strawberries - no rule triggered)
    When I add 1 unit of "Strawberries" to the cart
    Then the cart should contain 1 product
    And the total price should be £5.00

  @cart @basic
  Scenario: Add single item to cart (Coffee - no rule triggered)
    When I add 1 unit of "Coffee" to the cart
    Then the cart should contain 1 product
    And the total price should be £11.23

  @cart @basic
  Scenario: Combination of items below any discount threshold
    When I add 1 unit of "Green Tea" to the cart
    And I add 2 units of "Strawberries" to the cart
    And I add 1 unit of "Coffee" to the cart
    Then the cart should contain 4 products
    And the total price should be £24.34 # 3.11 + (2*5.00) + 11.23

  # Cart Modification Operations
  @cart @modification
  Scenario: Remove item from cart
    Given I add 1 unit of "Green Tea" to the cart
    And I add 1 unit of "Strawberries" to the cart
    When I remove "Green Tea" from the cart
    Then the cart should contain 1 product
    And the total price should be £5.00 # Only Strawberries remain

  # Incremental Cart Operations
  @cart @incremental
  Scenario: Add items incrementally to trigger a rule (Strawberries example)
    Given I add 2 units of "Strawberries" to the cart # Price = 10.00
    When I add 2 more units of "Strawberries" to the cart # Total 4 SR1, rule now applies
    Then the cart should contain 4 products
    And the total price should be £18.00 # 4 * 4.50 (Rule triggered for all 4 items)
    And I should see a message indicating the applied discount

  @cart @incremental
  Scenario: Add items incrementally involving BOGO (Green Tea example)
    Given I add 1 unit of "Green Tea" to the cart # Price = 3.11
    When I add 1 more unit of "Green Tea" to the cart # Total 2 GR1, BOGO applies
    Then the cart should contain 2 products
    And the total price should be £3.11 # Pay for 1
    And I should see a message indicating the applied discount

  # Green Tea - Buy One Get One Free Tests
  @free_rule
  Scenario: Apply "buy one, get one free" rule (at threshold)
    When I add 2 units of "Green Tea" to the cart
    Then the cart should contain 2 products
    And the total price should be £3.11 # Pay for 1
    And I should see a message indicating the applied discount

  @free_rule
  Scenario: Apply "buy one, get one free" rule with odd quantity
    When I add 3 units of "Green Tea" to the cart
    Then the cart should contain 3 products
    And the total price should be £6.22 # Pay for 2
    And I should see a message indicating the applied discount

  @free_rule
  Scenario: Apply "buy one, get one free" rule with even quantity above threshold
    When I add 4 units of "Green Tea" to the cart
    Then the cart should contain 4 products
    And the total price should be £6.22 # Pay for 2
    And I should see a message indicating the applied discount

  # Strawberries - Reduced Price Rule Tests
  @reduced_price_rule
  Scenario: Apply reduced price rule at threshold
    When I add 3 units of "Strawberries" to the cart
    Then the cart should contain 3 products
    And the total price should be £13.50 # 3 * £4.50
    And I should see a message indicating the applied discount

  @reduced_price_rule
  Scenario: Apply reduced price rule above threshold
    When I add 4 units of "Strawberries" to the cart
    Then the cart should contain 4 products
    And the total price should be £18.00 # 4 * £4.50
    And I should see a message indicating the applied discount

  # Coffee - Fraction Price Rule Tests
  @fraction_price_rule
  Scenario: Apply fraction price rule at threshold
    When I add 3 units of "Coffee" to the cart
    Then the cart should contain 3 products
    And the total price should be £22.47 # 3 * £7.49 (per-item rounded price)
    And I should see a message indicating the applied discount

  @fraction_price_rule
  Scenario: Apply fraction price rule above threshold
    When I add 4 units of "Coffee" to the cart
    Then the cart should contain 4 products
    And the total price should be £29.96 # 4 * £7.49 (per-item rounded price)
    And I should see a message indicating the applied discount

  # Multiple Discount Rules
  @multiple_rules
  Scenario: Apply multiple discount rules in a single purchase
    When I add 2 units of "Green Tea" to the cart      # Pays 3.11 (BOGO)
    And I add 3 units of "Strawberries" to the cart  # Pays 13.50 (3 * 4.50)
    And I add 3 units of "Coffee" to the cart      # Pays 22.47 (3 * 7.49)
    Then the cart should contain 8 products
    And the total price should be £39.08 # 3.11 + 13.50 + 22.47
    And I should see messages indicating the applied discounts

  @multiple_rules
  Scenario: Combination of items triggering multiple different rules
    When I add 3 units of "Green Tea" to the cart      # Pays for 2 -> 6.22
    And I add 4 units of "Strawberries" to the cart  # Pays 4 * 4.50 -> 18.00
    And I add 5 units of "Coffee" to the cart      # Pays 5 * 7.49 -> 37.45
    Then the cart should contain 12 products
    And the total price should be £61.67 # 6.22 + 18.00 + 37.45
    And I should see messages indicating the applied discounts

  # Configuration Tests
  @configuration
  Scenario: Load products from a custom file location
    Given the system is configured to load products from "custom/products.yml"
    When I start the cashier system
    Then the system should correctly load all products
    And I should be able to add products to the cart

  # Error Handling Tests
  @error_handling
  Scenario: Handle attempt to add negative quantity
    When I try to add -2 units of "Green Tea" to the cart
    Then the system should display an error message
    And the cart should be empty

  @error_handling
  Scenario: Handle attempt to add non-existent product
    When I try to add 1 unit of product with code "XX1" to the cart
    Then the system should display an error message
    And the cart should be empty