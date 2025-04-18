# Test Execution Plan for Cashier System

This document outlines a prioritized approach for executing the cashier system test cases, which correspond to scenarios in the [cashier.feature](bdd-specifications/cashier.feature) file.

## Test Design Strategy

Our test execution plan is designed based on the following principles:

1. **Risk-Based Prioritization**: Tests are prioritized based on their importance to core business functionality and potential impact of failures.

2. **Progressive Testing**: Starting with fundamental functionality before moving to more complex features.

3. **Dependency Consideration**: Tests are organized to account for dependencies between different system components.

4. **Efficiency**: Grouping related tests to minimize setup/teardown overhead.

## Execution Phases

### Phase 1: Core Functionality Tests (Critical Priority)

These tests verify the fundamental features of the cashier system:

1. **TC-PM-001**: Verify Product Loading from YAML
2. **TC-PM-002**: Add Single Product to Cart
3. **TC-PM-003**: Add Multiple Units of Same Product
4. **TC-PM-004**: Add Different Products to Cart
5. **TC-DR-001**: Free Rule - Buy One Get One Free (Green Tea)
6. **TC-DR-004**: Reduced Price Rule - Buy More Than N Pay X Price (Strawberries)
7. **TC-DR-006**: Fraction Price Rule - Buy More Than N Pay X% (Coffee)
8. **TC-DR-008**: Multiple Discount Rules Applied to Different Products

**Rationale**: These tests cover the basic cart operations and each discount rule type, which are essential for the system to be considered functional. Product loading is tested first as other functionality depends on it.

### Phase 2: Extended Functionality Tests (High Priority)

These tests verify additional important features:

1. **TC-DR-002**: Free Rule - Buy One Get One Free (Multiple Pairs)
2. **TC-DR-003**: Free Rule - Buy One Get One Free (Odd Number)
3. **TC-DR-005**: Reduced Price Rule - Above Threshold
4. **TC-DR-007**: Fraction Price Rule - Above Threshold
5. **TC-DR-009**: Combination of items triggering multiple rules
6. **TC-PM-005**: Update Product Quantity in Cart
7. **TC-PM-006**: Remove Product from Cart
8. **TC-PM-007**: Clear Cart
9. **TC-PM-008**: Empty Cart Total Price
10. **TC-DR-010**: Add items incrementally to trigger a rule

**Rationale**: These tests cover additional important scenarios that extend the basic functionality, including additional discount threshold tests and cart management operations.

### Phase 3: Configuration and Less Common Scenarios (Medium Priority)

1. **TC-CF-001**: Custom Product File Path
2. **TC-CF-002**: Custom Rules File Path
3. **TC-EC-004**: Multiple Applicable Discount Rules
4. **TC-UI-001**: Cart Display Accuracy (if applicable)
5. **TC-UI-002**: Discount Visibility (if applicable)

**Rationale**: These tests verify configuration capabilities and less common scenarios that are important for flexibility but not critical for core functionality.

### Phase 4: Edge Cases and Error Handling (Lower Priority)

1. **TC-EC-001**: Very Large Quantities
2. **TC-EC-002**: Negative Quantities
3. **TC-EC-003**: Non-existent Product Code
4. **TC-CF-003**: Invalid Products YAML Format
5. **TC-CF-004**: Invalid Rules YAML Format

**Rationale**: These tests verify the system's behavior in unusual or error conditions. While important for robustness, failures in these areas would generally have less impact than failures in core functionality.

## Test Dependencies

Some tests have dependencies that should be considered:

- Configuration tests (TC-CF-*) require working product loading (TC-PM-001)
- Discount tests (TC-DR-*) require working cart functionality (TC-PM-*)
- Multiple discount test (TC-DR-008) requires individual discount rules to work correctly
- UI tests (TC-UI-*) depend on all underlying functionality working correctly

These dependencies have been considered in the phase ordering to minimize the impact of failures.

## Success Criteria

Test execution is considered successful when:

1. All Phase 1 (Critical Priority) tests pass without issues
2. At least 90% of Phase 2 (High Priority) tests pass without issues
3. No critical or high-severity defects are found
4. All defects are documented with clear steps to reproduce

## Test Data Requirements

### Products Data
- Green Tea (GR1): £3.11
- Strawberries (SR1): £5.00
- Coffee (CF1): £11.23

### Discount Rules Data
- Free Rule (Buy N get N free): Configured for Green Tea (Buy 1 get 1 free)
- Reduced Price Rule (Buy > N pay X price): Configured for Strawberries (Buy 3 or more, pay £4.50 each)
- Fraction Price Rule (Buy > N pay X% of original price): Configured for Coffee (Buy 3 or more, pay 2/3 of price)

## Test Environment Requirements

- Valid YAML files for configuration:
  - Products: [products.yml](config/products.yml)
  - Rules: [rules.yml](config/rules.yml)
- Alternative YAML files for configuration tests
- Invalid YAML files for error handling tests

The system should allow configuration of the file paths, with the default location for these files being determined by the implementation.

## Defect Management

For any defects found during testing:

1. Document the defect with:
   - Test case ID
   - Steps to reproduce
   - Expected vs. actual results
   - Screenshots/recordings if applicable
   - Severity classification:
     - **Critical**: Prevents core functionality from working
     - **High**: Significant feature doesn't work correctly
     - **Medium**: Feature works but has limitations
     - **Low**: Minor issues that don't affect functionality
2. Track defects until resolution
3. Perform regression testing on fixed defects

## Reporting

At the conclusion of testing, a test summary report will be created documenting:

1. Test cases executed
2. Pass/fail status for each test case
3. Defects found and their status
4. Overall assessment of system quality
5. Recommendations for improvement

This report will provide stakeholders with a clear understanding of the system's quality and any remaining issues.
