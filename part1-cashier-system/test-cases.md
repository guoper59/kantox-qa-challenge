--- START OF FILE test-cases.md ---

# Test Cases for Cashier System

These test cases correspond to scenarios in the [cashier.feature](bdd-specifications/cashier.feature) file and use the sample [products.yml](config/products.yml) and [rules.yml](config/rules.yml) configuration.

## Justification for Test Case Selection

This document contains a comprehensive set of test cases designed to validate the cashier system's functionality. The selection of test cases is based on the following principles:

1.  **Comprehensive Coverage**: Test cases cover all core functionalities of the system including product management, discount rules application, configuration handling, and edge cases.
2.  **Priority-Based Approach**: Test cases are prioritized based on their importance to the core business functionality, with critical operations like discount calculations and price totaling receiving highest priority.
3.  **Structured Test Design Techniques**: We've applied formal test design methods to ensure systematic coverage:
    *   Equivalence Partitioning: Dividing input quantities into classes that should behave similarly
    *   Boundary Value Analysis: Special focus on threshold values for discount rules
    *   Decision Table Testing: Considering combinations of products and quantities
    *   State Transition Testing: Validating cart behavior through different operations
4.  **Error Handling**: Test cases specifically check how the system responds to invalid inputs, non-existent product codes, and malformed configuration files.
5.  **Real-world Scenarios**: The test cases simulate real shopping scenarios where multiple products and multiple discount rules might apply simultaneously.

*(Note: API testing assumptions are detailed separately in the main [README.md](README.md) file)*

## 1. Product Management Tests

**Justification**: Product management is the foundation of the cashier system. Before testing discount rules, we must ensure that the system correctly loads products, adds them to the cart, and maintains proper cart state. These tests verify the core operations required for a functional cashier system.

| ID        | Description                              | Test Design Technique | Steps                                                                                   | Expected Result                                                               | Priority |
| :-------- | :--------------------------------------- | :-------------------- | :-------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- | :------- |
| TC-PM-001 | Verify product loading from YAML         | Basic Functionality   | 1. Start the cashier system                                                             | System loads all products with correct codes, names, and prices from YAML     | High     |
| TC-PM-002 | Add single product to cart               | Basic Functionality   | 1. Add Green Tea (GR1) to cart<br>2. View cart                                          | Cart contains 1 unit of Green Tea with price £3.11 (before discounts)         | High     |
| TC-PM-003 | Add multiple units of same product     | Equivalence Partitioning | 1. Add 3 units of Strawberries (SR1) to cart<br>2. View cart                           | Cart contains 3 units of Strawberries with price £15.00 (before discounts)    | High     |
| TC-PM-004 | Add different products to cart         | Decision Table        | 1. Add Green Tea, Strawberries, and Coffee<br>2. View cart                              | Cart contains all 3 products with correct total £19.34 (before discounts)       | High     |
| TC-PM-005 | Update existing product quantity       | State Transition      | 1. Add 1 Green Tea<br>2. Update quantity of Green Tea to 3 units<br>3. View cart           | Cart shows 3 Green Tea with updated price £9.33 (before discounts)            | Medium   |
| TC-PM-006 | Remove product from cart               | State Transition      | 1. Add GR1, SR1, CF1<br>2. Remove Strawberries (SR1)<br>3. View cart                    | Cart no longer contains Strawberries, total updated correctly (£14.34 before discounts) | Medium   |
| TC-PM-007 | Clear entire cart                      | State Transition      | 1. Add GR1 and SR1<br>2. Clear cart<br>3. View cart                                     | Cart is empty with £0.00 total                                                | Medium   |
| TC-PM-008 | Empty cart total price calculation     | Boundary Value        | 1. Start with empty cart<br>2. View total for empty cart                                  | Total shows £0.00                                                             | Low      |

## 2. Discount Rule Tests

**Justification**: Discount rule application is a critical business function. These tests verify that all three types of discount rules work correctly in isolation and combination, including at thresholds (boundary testing). Assumes specific rounding and rule interaction logic (see Assumptions section below). Prices shown are *final* discounted prices.

| ID        | Description                                                  | Test Design Technique | Steps                                                                                    | Expected Result                                                                   | Priority |
| :-------- | :----------------------------------------------------------- | :-------------------- | :--------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- | :------- |
| TC-DR-001 | Free Rule - Buy One Get One Free (Green Tea - threshold)     | Boundary Value        | 1. Add 2 units of Green Tea<br>2. View cart total                                        | Total price shows £3.11 (price of 1 unit)                                         | Critical |
| TC-DR-002 | Free Rule - Buy One Get One Free (Multiple Pairs)            | Equivalence Partitioning | 1. Add 4 units of Green Tea<br>2. View cart total                                        | Total price shows £6.22 (price of 2 units)                                        | High     |
| TC-DR-003 | Free Rule - Buy One Get One Free (Odd Number)                | Boundary Value        | 1. Add 3 units of Green Tea<br>2. View cart total                                        | Total price shows £6.22 (pay for 2: BOGO applies to 2, 1 full price)              | High     |
| TC-DR-004 | Reduced Price Rule - Buy >= 3 Pay £4.50 (Strawberries - threshold) | Boundary Value        | 1. Add 2 Strawberries (price £10.00)<br>2. Add 1 more (total 3)<br>3. View cart total     | With 3 units: £13.50 (3 × £4.50)                                                  | Critical |
| TC-DR-005 | Reduced Price Rule - Above Threshold                         | Equivalence Partitioning | 1. Add 4 units of Strawberries<br>2. View cart total                                     | Total price shows £18.00 (4 × £4.50)                                              | High     |
| TC-DR-006 | Fraction Price Rule - Buy >= 3 Pay 2/3 (Coffee - threshold)  | Boundary Value        | 1. Add 2 Coffee (price £22.46)<br>2. Add 1 more (total 3)<br>3. View cart total          | With 3 units: £22.47 (3 × £11.23 × 2/3 = 3 * 7.4866.. rounded to 7.49 each = 22.47) | Critical |
| TC-DR-007 | Fraction Price Rule - Above Threshold                        | Equivalence Partitioning | 1. Add 4 units of Coffee<br>2. View cart total                                          | Total price shows £29.96 (4 × £7.49)                                              | High     |
| TC-DR-008 | Multiple Discount Rules Applied (Different Products)         | Decision Table        | 1. Add 2 GR1<br>2. Add 3 SR1<br>3. Add 3 CF1<br>4. View cart total                     | Total shows £39.08 (£3.11 + £13.50 + £22.47)                                      | Critical |
| TC-DR-009 | Complex Combination triggering multiple rules                | Decision Table        | 1. Add 3 GR1<br>2. Add 4 SR1<br>3. Add 5 CF1<br>4. View cart total                     | Total shows £61.68 (£6.22 + £18.00 + £37.45 [5 * 7.49])                           | High     |
| TC-DR-010 | Add items incrementally to trigger a rule                    | State Transition      | 1. Add 2 Strawberries (£10.00)<br>2. Add 2 more Strawberries<br>3. View cart total        | Total shows £18.00 (rule triggered for all 4 items at £4.50 each)                 | Medium   |

## 3. Configuration Tests

**Justification**: The system's ability to read configuration from YAML files is a core requirement. Assumes YAML files follow the sample structure.

| ID        | Description                      | Test Design Technique | Steps                                                                                             | Expected Result                                                               | Priority |
| :-------- | :------------------------------- | :-------------------- | :------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------- | :------- |
| TC-CF-001 | Custom Product File Path         | Configuration         | 1. Configure system to use custom/path/to/products.yml<br>2. Start system<br>3. Verify products   | Products loaded correctly from the specified custom location                  | Medium   |
| TC-CF-002 | Custom Rules File Path           | Configuration         | 1. Configure system to use custom/path/to/rules.yml<br>2. Start system<br>3. Add products        | Discount rules applied correctly based on the specified custom location       | Medium   |
| TC-CF-003 | Invalid Products YAML Format     | Error Handling        | 1. Replace products.yml with a file containing invalid YAML syntax<br>2. Start system           | System handles error gracefully (e.g., logs error, fails to start with message) | Low      |
| TC-CF-004 | Invalid Rules YAML Format        | Error Handling        | 1. Replace rules.yml with a file containing invalid YAML syntax<br>2. Start system<br>3. Add items | System handles error gracefully (e.g., logs error, defaults to no discounts)  | Low      |

## 4. Edge Cases and Error Handling Tests

**Justification**: Verifies system robustness under unusual conditions. Assumes basic input validation.

| ID        | Description                                                  | Test Design Technique | Steps                                                                                                                             | Expected Result                                                                     | Priority |
| :-------- | :----------------------------------------------------------- | :-------------------- | :-------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------- | :------- |
| TC-EC-001 | Very Large Quantities (Calculation Accuracy/Performance)     | Boundary Value        | 1. Add 10,000 units of Green Tea<br>2. View cart total                                                                            | System correctly calculates total (£15,550 based on 5000 paid units) without errors | Low      |
| TC-EC-002 | Negative Quantities                                          | Error Handling        | 1. Try to add -2 units of Green Tea                                                                                               | System rejects operation with appropriate error message, cart state unchanged     | Low      |
| TC-EC-003 | Non-existent Product Code                                    | Error Handling        | 1. Try to add product with code "XX1"                                                                                             | System rejects operation with appropriate error message, cart state unchanged     | Low      |
| TC-EC-004 | Multiple Applicable Discount Rules (Hypothetical - if allowed) | Decision Table        | 1. Configure multiple conflicting rules for same product (e.g., BOGO & % off)<br>2. Add product<br>3. View cart total            | System applies *only* the single most beneficial discount for the customer        | Medium   |
| TC-EC-005 | Add Zero Quantity                                            | Boundary Value        | 1. Try to add 0 units of Green Tea to the cart                                                                                    | Operation is ignored or rejected, cart state unchanged                              | Low      |
| TC-EC-006 | Update Quantity to Zero                                      | State Transition      | 1. Add 2 Green Tea to cart<br>2. Update quantity of Green Tea to 0                                                                 | Green Tea item is removed from the cart, total price updated                      | Medium   |

## 5. User Interface Tests (if applicable)

**Justification**: Ensures accurate display if a UI exists.

| ID        | Description             | Test Design Technique | Steps                                                                                    | Expected Result                                                                                           | Priority |
| :-------- | :---------------------- | :-------------------- | :--------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- | :------- |
| TC-UI-001 | Cart Display Accuracy   | UI Validation         | 1. Add various products with different quantities to the cart<br>2. View the cart display | The cart display accurately shows all products, their quantities, individual prices, and the total price | Medium   |
| TC-UI-002 | Discount Visibility     | UI Validation         | 1. Add products that trigger different discount rules<br>2. View the cart display       | Applied discounts (or discounted prices) are clearly visible per item or on the total                     | Medium   |

## Key Assumptions for Cashier System Tests

These assumptions underpin the expected results defined in the test cases above. See the main [README.md](README.md) for a comprehensive list including API testing assumptions.

1.  **Rule Interaction Logic:** If multiple discount rules could apply to a single product line, only the single most beneficial rule (lowest price for the customer) is applied.
2.  **Rounding Behavior:** Fractional prices resulting from percentage discounts (`FractionPriceRule`) are rounded to the nearest £0.01 per item before summing line totals.
3.  **Discount Thresholds:** Rules trigger at the specified quantity (e.g., "Buy 3 or more" triggers at quantity 3).
4.  **Input Validation:** The system is expected to validate basic inputs, rejecting negative quantities and unknown product codes.
5.  **Configuration Structure:** The system correctly parses YAML configuration files matching the structure of the provided samples.