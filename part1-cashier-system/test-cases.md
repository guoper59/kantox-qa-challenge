# Test Cases for Cashier System

These test cases correspond to scenarios in the [cashier.feature](bdd-specifications/cashier.feature) file and use the sample [products.yml](config/products.yml) and [rules.yml](config/rules.yml) configuration.

## Justification for Test Case Selection

This document contains a comprehensive set of test cases designed to validate the cashier system's functionality. The selection of test cases is based on the following principles:

1. **Comprehensive Coverage**: Test cases cover all core functionalities of the system including product management, discount rules application, configuration handling, and edge cases.

2. **Priority-Based Approach**: Test cases are prioritized based on their importance to the core business functionality, with critical operations like discount calculations and price totaling receiving highest priority.

3. **Structured Test Design Techniques**: We've applied formal test design methods to ensure systematic coverage:
   - **Equivalence Partitioning**: Dividing input quantities into classes that should behave similarly
   - **Boundary Value Analysis**: Special focus on threshold values for discount rules
   - **Decision Table Testing**: Considering combinations of products and quantities
   - **State Transition Testing**: Validating cart behavior through different operations

4. **Error Handling**: Test cases specifically check how the system responds to invalid inputs, non-existent product codes, and malformed configuration files.

5. **Real-world Scenarios**: The test cases simulate real shopping scenarios where multiple products and multiple discount rules might apply simultaneously.

## 1. Product Management Tests

**Justification**: Product management is the foundation of the cashier system. Before testing discount rules, we must ensure that the system correctly loads products, adds them to the cart, and maintains proper cart state. These tests verify the core operations required for a functional cashier system.

| ID | Description | Test Design Technique | Steps | Expected Result | Priority |
|----|-------------|----------------------|-------|-----------------|----------|
| TC-PM-001 | Verify product loading from YAML | Basic Functionality | 1. Start the cashier system | System loads all products with correct codes, names, and prices | High |
| TC-PM-002 | Add single product to cart | Basic Functionality | 1. Add Green Tea (GR1) to cart<br>2. View cart | Cart contains 1 unit of Green Tea with price £3.11 | High |
| TC-PM-003 | Add multiple units of same product | Equivalence Partitioning | 1. Add 3 units of Strawberries (SR1) to cart<br>2. View cart | Cart contains 3 units of Strawberries with price £15.00 (before discounts) | High |
| TC-PM-004 | Add different products to cart | Decision Table | 1. Add Green Tea, Strawberries, and Coffee<br>2. View cart | Cart contains all products with correct total (£19.34 before discounts) | High |
| TC-PM-005 | Update product quantity | State Transition | 1. Add 1 Green Tea<br>2. Update to 3 units<br>3. View cart | Cart shows 3 Green Tea with updated price (£9.33 before discounts) | Medium |
| TC-PM-006 | Remove product from cart | State Transition | 1. Add multiple products<br>2. Remove Strawberries<br>3. View cart | Cart no longer contains Strawberries, total updated | Medium |
| TC-PM-007 | Clear cart | State Transition | 1. Add products<br>2. Clear cart<br>3. View cart | Cart is empty with £0.00 total | Medium |
| TC-PM-008 | Empty cart total price | Boundary Value | 1. View total for empty cart | Total shows £0.00 | Low |

## 2. Discount Rule Tests

**Justification**: Discount rule application is a critical business function of the cashier system. These tests verify that all three types of discount rules (FreeRule, ReducedPriceRule, and FractionPriceRule) work correctly in isolation and in combination. We've designed tests for various quantity combinations to ensure rules apply at exactly the threshold (boundary testing) and beyond. Special attention is given to odd numbers for the "Buy one get one free" rule to verify correct handling of non-even quantities.

| ID | Description | Test Design Technique | Steps | Expected Result | Priority |
|----|-------------|----------------------|-------|-----------------|----------|
| TC-DR-001 | Free Rule - Buy One Get One Free (Green Tea) | Boundary Value | 1. Add 2 units of Green Tea<br>2. View cart total | Total price shows £3.11 (price of 1 unit) | Critical |
| TC-DR-002 | Free Rule - Buy One Get One Free (Multiple Pairs) | Equivalence Partitioning | 1. Add 4 units of Green Tea<br>2. View cart total | Total price shows £6.22 (price of 2 units) | High |
| TC-DR-003 | Free Rule - Buy One Get One Free (Odd Number) | Boundary Value | 1. Add 3 units of Green Tea<br>2. View cart total | Total price shows £6.22 (2 for price of 1, plus 1 at full price) | High |
| TC-DR-004 | Reduced Price Rule - Buy More Than N Pay X Price (Strawberries) | Boundary Value | 1. Add 1 Strawberry, check price<br>2. Add 2 more (total 3)<br>3. View cart total | With 1 unit: £5.00<br>With 3 units: £13.50 (£4.50 each) | Critical |
| TC-DR-005 | Reduced Price Rule - Above Threshold | Equivalence Partitioning | 1. Add 4 units of Strawberries<br>2. View cart total | Total price shows £18.00 (4 × £4.50) | High |
| TC-DR-006 | Fraction Price Rule - Buy More Than N Pay X% (Coffee) | Boundary Value | 1. Add 2 Coffee, check price<br>2. Add 1 more (total 3)<br>3. View cart total | With 2 units: £22.46<br>With 3 units: £22.46 (3 × £11.23 × 2/3, rounded per item) | Critical |
| TC-DR-007 | Fraction Price Rule - Above Threshold | Equivalence Partitioning | 1. Add 4 units of Coffee<br>2. View cart total | Total price shows £29.95 (4 × £11.23 × 2/3, rounded per item) | High |
| TC-DR-008 | Multiple Discount Rules Applied to Different Products | Decision Table | 1. Add 2 Green Tea<br>2. Add 3 Strawberries<br>3. Add 3 Coffee<br>4. View cart total | Total shows £39.07 (all discounts applied correctly) | Critical |
| TC-DR-009 | Combination of items triggering multiple rules | Decision Table | 1. Add 3 Green Tea<br>2. Add 4 Strawberries<br>3. Add 5 Coffee<br>4. View cart total | Total shows £61.67 (6.22 + 18.00 + 37.45) | High |
| TC-DR-010 | Add items incrementally to trigger a rule | State Transition | 1. Add 2 Strawberries<br>2. Add 2 more Strawberries<br>3. View cart total | Total shows £18.00 (rule triggered for all 4 items) | Medium |

## 3. Configuration Tests

**Justification**: The system's ability to read configuration from YAML files is a core requirement. These tests verify that the system can load configurations from both default and custom file paths, ensuring flexibility in deployment. Testing with invalid YAML files is crucial to ensure graceful error handling and system stability when configuration issues arise. These tests are particularly important because configuration errors could potentially affect all system operations.

| ID | Description | Test Design Technique | Steps | Expected Result | Priority |
|----|-------------|----------------------|-------|-----------------|----------|
| TC-CF-001 | Custom Product File Path | Configuration | 1. Configure custom products path<br>2. Start system<br>3. Verify products | Products loaded correctly from custom location | Medium |
| TC-CF-002 | Custom Rules File Path | Configuration | 1. Configure custom rules path<br>2. Start system<br>3. Add products to trigger discounts | Discount rules applied correctly from custom location | Medium |
| TC-CF-003 | Invalid Products YAML Format | Error Handling | 1. Replace products.yml with invalid format<br>2. Start system | System handles error gracefully with appropriate message | Low |
| TC-CF-004 | Invalid Rules YAML Format | Error Handling | 1. Replace rules.yml with invalid format<br>2. Start system<br>3. Add products | System handles error gracefully, possibly defaulting to no discounts | Low |

## 4. Edge Cases and Error Handling Tests

**Justification**: Edge case testing ensures the system behaves correctly under unusual or extreme conditions. These tests verify the system's robustness by checking its response to empty carts, very large quantities, negative quantities, and non-existent product codes. Proper error handling is essential for maintaining system stability and providing appropriate feedback to users. These cases, while less common in day-to-day operation, are critical for ensuring the system can handle unexpected inputs gracefully.

| ID | Description | Test Design Technique | Steps | Expected Result | Priority |
|----|-------------|----------------------|-------|-----------------|----------|
| TC-EC-001 | Very Large Quantities | Boundary Value | 1. Add 1000 units of Green Tea<br>2. View cart total | System correctly calculates total with appropriate discount | Low |
| TC-EC-002 | Negative Quantities | Error Handling | 1. Try to add -2 units of Green Tea | System rejects operation with appropriate error message | Low |
| TC-EC-003 | Non-existent Product Code | Error Handling | 1. Try to add product with code "XX1" | System rejects operation with appropriate error message | Low |
| TC-EC-004 | Multiple Applicable Discount Rules | Decision Table | 1. Configure multiple rules for same product<br>2. Add product<br>3. View cart total | System applies most beneficial discount for customer | Medium |

## 5. User Interface Tests (if applicable)

**Justification**: While the challenge doesn't explicitly mention a user interface, most cashier systems have some form of display showing cart contents and prices. These tests ensure that if a UI exists, it accurately displays all relevant information including products, quantities, prices, and applied discounts. Clear visibility of this information is essential for both cashiers and customers. These tests are marked as "if applicable" since we're making an assumption about the existence of a UI component.

| ID | Description | Test Design Technique | Steps | Expected Result | Priority |
|----|-------------|----------------------|-------|-----------------|----------|
| TC-UI-001 | Cart Display Accuracy | UI Validation | 1. Add various products with different quantities to the cart<br>2. View the cart display | The cart display should accurately show all products, their quantities, individual prices, and the total price | Medium |
| TC-UI-002 | Discount Visibility | UI Validation | 1. Add products that would trigger different discount rules<br>2. View the cart display | The applied discounts should be clearly visible to the user, showing the original price, the discount applied, and the final price | Medium |

## Development Guidance

1. **Focus Areas**:
   - Ensuring all discount rules calculate correctly, especially at boundary conditions
   - Proper handling of configuration files with robust error handling
   - Input validation for all user inputs
   - Rounding behavior for fractional price calculations (per item rounding)

2. **Potential Edge Cases**:
   - Adding a product with quantity zero
   - Updating quantity to zero (should remove product)
   - Decimal quantities if allowed
   - Very large quantities that might cause numeric overflow

3. **Test Data Requirements**:
   - Products: Green Tea (£3.11), Strawberries (£5.00), Coffee (£11.23)
   - Rules: Buy one get one free (Green Tea), Buy 3+ pay £4.50 each (Strawberries), Buy 3+ pay 2/3 price (Coffee)
   
4. **Configuration Files**:
   - The sample configuration files are located in the [config directory](config/) 
   - The system should support specifying custom paths for these configuration files
