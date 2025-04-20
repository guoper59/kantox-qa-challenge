# Test Execution Plan for Cashier System

This document outlines a prioritized approach for executing the cashier system test cases documented in [test-cases.md](test-cases.md), which correspond to scenarios in the [cashier.feature](bdd-specifications/cashier.feature) file.

## Test Design Strategy

Our test execution plan is designed based on the following principles:

1.  **Risk-Based Prioritization**: Tests are prioritized based on their importance to core business functionality and potential impact of failures. Critical discount calculations and basic cart operations are tested first.
2.  **Progressive Testing**: Starting with fundamental functionality (loading products, adding items) before moving to more complex features (discount combinations, edge cases).
3.  **Dependency Consideration**: Tests are organized to account for dependencies (e.g., cart functionality must work before complex discount tests).
4.  **Efficiency**: Grouping related tests (e.g., all tests for a specific discount rule) to minimize setup/teardown overhead where possible.

## Execution Phases

### Phase 1: Core Functionality & Rule Thresholds (Critical Priority)

These tests verify the absolute fundamental features required for the system to operate and apply basic discounts correctly at their trigger points.

1.  **TC-PM-001**: Verify Product Loading from YAML
2.  **TC-PM-002**: Add Single Product to Cart
3.  **TC-PM-003**: Add Multiple Units of Same Product
4.  **TC-PM-004**: Add Different Products to Cart
5.  **TC-DR-001**: Free Rule - Buy One Get One Free (Green Tea - threshold)
6.  **TC-DR-004**: Reduced Price Rule - Buy >= 3 Pay £4.50 (Strawberries - threshold)
7.  **TC-DR-006**: Fraction Price Rule - Buy >= 3 Pay 2/3 (Coffee - threshold)
8.  **TC-DR-008**: Multiple Discount Rules Applied (Different Products)

**Rationale**: Covers basic product handling and ensures each discount type works at its minimum trigger quantity. Verifies the core calculation engine for single rules and a simple combination. Essential for basic functionality.

### Phase 2: Extended Rule Application & Cart Management (High Priority)

These tests verify additional important rule scenarios and core cart management operations beyond just adding items.

1.  **TC-DR-002**: Free Rule - Buy One Get One Free (Multiple Pairs)
2.  **TC-DR-003**: Free Rule - Buy One Get One Free (Odd Number)
3.  **TC-DR-005**: Reduced Price Rule - Above Threshold
4.  **TC-DR-007**: Fraction Price Rule - Above Threshold
5.  **TC-DR-009**: Complex Combination triggering multiple rules
6.  **TC-PM-005**: Update existing product quantity
7.  **TC-PM-006**: Remove product from cart
8.  **TC-PM-007**: Clear entire cart
9.  **TC-DR-010**: Add items incrementally to trigger a rule

**Rationale**: Covers rule behavior beyond the initial threshold, important variations (like odd quantities for BOGO), complex combinations, and essential cart state management (update, remove, clear), ensuring the cart behaves correctly through typical user actions.

### Phase 3: Configuration, Specific Edge Cases & UI (Medium Priority)

These tests cover configuration flexibility, specific functional edge cases, and UI checks (if applicable).

1.  **TC-CF-001**: Custom Product File Path
2.  **TC-CF-002**: Custom Rules File Path
3.  **TC-EC-004**: Multiple Applicable Discount Rules (Hypothetical - if allowed)
4.  **TC-EC-006**: Update Quantity to Zero (results in item removal)
5.  **TC-UI-001**: Cart Display Accuracy (if applicable)
6.  **TC-UI-002**: Discount Visibility (if applicable)

**Rationale**: Verifies non-default configurations, handling of potential rule conflicts, the specific case of zeroing out quantity via update, and presentation layer accuracy. Important for flexibility and usability but secondary to core calculations.

### Phase 4: Robustness, Error Handling & Low Priority Checks (Lower Priority)

These tests verify the system's behavior under unusual conditions, invalid inputs, and configuration errors.

1.  **TC-PM-008**: Empty cart total price calculation
2.  **TC-EC-001**: Very Large Quantities (Calculation Accuracy/Performance)
3.  **TC-EC-002**: Negative Quantities (Input Rejection)
4.  **TC-EC-003**: Non-existent Product Code (Input Rejection)
5.  **TC-EC-005**: Add Zero Quantity (Input Rejection/Ignored)
6.  **TC-CF-003**: Invalid Products YAML Format (Error Handling)
7.  **TC-CF-004**: Invalid Rules YAML Format (Error Handling)

**Rationale**: Focuses on system stability and graceful error handling when faced with invalid data or configuration issues. While important for a robust system, failures here are generally less impactful on core positive flows than failures in earlier phases.

## Test Dependencies

Key dependencies influencing the execution order:

*   Product Loading (`TC-PM-001`) must pass before any cart operations or discount tests.
*   Basic Add-to-Cart (`TC-PM-002`, `TC-PM-003`, `TC-PM-004`) must pass before testing discounts or other cart management actions.
*   Individual discount rules (`TC-DR-001`, `TC-DR-004`, `TC-DR-006`) should ideally work before testing complex combinations (`TC-DR-008`, `TC-DR-009`).
*   Configuration tests (`TC-CF-*`) depend on the basic system startup and product loading mechanisms.
*   UI tests (`TC-UI-*`) depend on all underlying cart and discount logic working correctly.

These dependencies are inherently reflected in the phased approach.

## Success Criteria

Test execution is considered successful for a release candidate when:

1.  All Phase 1 (Critical Priority) tests pass.
2.  All Phase 2 (High Priority) tests pass.
3.  At least 95% of Phase 3 (Medium Priority) tests pass, with clear justification and risk assessment for any failures.
4.  No Critical or High severity defects remain open.
5.  All defects found during execution are documented with clear steps to reproduce, severity, and priority assigned.

## Test Data Requirements

### Products Data (from `products.yml`)
*   Green Tea (GR1): £3.11
*   Strawberries (SR1): £5.00
*   Coffee (CF1): £11.23

### Discount Rules Data (from `rules.yml`)
*   GR1: Buy 1 get 1 free (FreeRule, N=1, M=1)
*   SR1: Buy 3 or more, pay £4.50 each (ReducedPriceRule, N=3, X=4.50)
*   CF1: Buy 3 or more, pay 2/3 of price (~£7.49 each) (FractionPriceRule, N=3, Percentage=66.666...)

## Test Environment Requirements

*   Access to the cashier system/application build under test.
*   Ability to configure the system to use default and custom paths for YAML files.
*   Valid YAML files for products and rules (e.g., `config/products.yml`, `config/rules.yml`).
*   Sample invalid YAML files for testing error handling (`TC-CF-003`, `TC-CF-004`).

## Defect Management

Any deviations from expected results will be logged as defects using a standard tracking tool (e.g., Jira, Trello). Each defect report will include:

1.  Test Case ID (if applicable)
2.  Clear, concise title
3.  Build/Version number where defect was found
4.  Detailed steps to reproduce
5.  Expected Result vs. Actual Result
6.  Screenshots/Logs (if applicable)
7.  Severity (Critical, High, Medium, Low)
8.  Priority (Blocker, High, Medium, Low)

Defects will be tracked through their lifecycle (Open, In Progress, Ready for QA, Closed). Regression testing will be performed on fixed defects.

## Reporting

A Test Summary Report will be generated at the end of the execution cycle, detailing:

1.  Scope of testing (which phases/test cases were executed).
2.  Summary of results (Pass/Fail counts per priority/phase).
3.  List of open defects with severity/priority.
4.  Overall assessment of quality based on Success Criteria.
5.  Any identified risks or recommendations.

This provides stakeholders with a clear view of the system's quality state.