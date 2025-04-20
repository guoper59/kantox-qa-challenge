# Kantox QA Engineer Challenge Solution

This repository contains a solution for the Kantox QA Engineer Challenge with comprehensive test cases and API tests.

## Repository Structure

```
.
├── README.md                           # This file: Main documentation, setup, assumptions
├── part1-cashier-system/               # Cashier system tests
│   ├── bdd-specifications/             # BDD specifications in Gherkin
│   │   └── cashier.feature             # Cashier system scenarios
│   ├── config/                            # Example configuration
│   │   ├── products.yml                # Sample products
│   │   └── rules.yml                   # Sample discount rules
│   ├── test-cases.md                   # Detailed test cases with links & assumptions
│   └── test-execution-plan.md          # Prioritized execution plan
│
└── part2-api-testing/                  # API tests
    ├── bdd-specifications/             # BDD specifications in Gherkin
    │   └── api.feature                 # API test scenarios
    ├── collection.json                 # Postman collection with contract tests
    ├── db.json                         # Working database file (overwritten on start)
    ├── db.seed.json                    # Seed database file with initial state
    └── package.json                    # Dependencies and start script for JSON server
```

## Overall QA Strategy & Justifications

Our approach follows industry best practices, emphasizing:

-   **Risk-Based Testing:** Focusing tests on key functional areas (discount rule logic, API CRUD operations) and potential weaknesses (boundaries, rule interactions).
-   **Requirements-Driven Design:** Ensuring all specified functionalities and endpoints are covered.
-   **Structured Test Design Techniques:** Utilizing formal methods (EP, BVA, decision tables, state transitions) for systematic coverage.
-   **Clear Documentation & Justification:** Explaining the *why* behind the approach and assumptions (`defense.md`).
-   **Adherence to ISTQB Principles:** Applying standard terminology and concepts throughout the test documentation.

## Part 1: Cashier System Test Cases

The [test cases](part1-cashier-system/test-cases.md) cover:

-   Basic cart operations (add, update, remove products)
-   Discount rule application:
    -   Buy one get one free (FreeRule)
    -   Reduced price for bulk purchases (ReducedPriceRule)
    -   Percentage discounts (FractionPriceRule)
-   Configuration handling and file loading
-   Edge cases and error conditions

A [test execution plan](part1-cashier-system/test-execution-plan.md) prioritizes these tests for efficient implementation.

### Test Design Techniques Used

-   **Equivalence Partitioning (EP):** Dividing input quantities into valid and invalid classes.
-   **Boundary Value Analysis (BVA):** Testing at and around discount thresholds (N-1, N, N+1).
-   **Decision Table Thinking:** Ensuring combinations of products and quantities are covered.
-   **State Transition Testing:** Used for cart operations (empty → add → update → remove).
-   **Gherkin (BDD Syntax):** Used to present test cases in a clear, business-readable format in `part1-cashier-system/bdd-specifications/`.

### Key Assumptions (Parts 1 & 2)

The following assumptions were made during the design of the tests:

1.  **Rule Interaction (Part 1):** When multiple different discount rules could theoretically apply to the same product line item, the system implements logic to apply *only* the single rule that results in the greatest benefit (lowest price) for the customer. (Tested in `TC-EC-004`).
2.  **Rule Thresholds (Part 1):** Discount rules phrased as "Buy N or more" or "Buy > N-1" trigger when the quantity is exactly N and above. "Buy N get M free" triggers when the quantity reaches N.
3.  **Rounding Behavior (Part 1):** For the `FractionPriceRule`, percentage calculations yielding fractional currency values are rounded to 2 decimal places (nearest penny) **per individual item** *before* these rounded item prices are summed for the total. (e.g., £11.23 \* 2/3 = £7.4866... rounded to £7.49 per item).
4.  **Input Validation (Part 1 & 2):** The systems perform basic input validation. For Part 1, this means rejecting negative quantities or attempts to add non-existent product codes. For Part 2, this relates to assumption #7.
5.  **Product-Level Discounts (Part 1):** Discounts are calculated based on the quantity and rules applicable to individual product line items in the cart, not based on overall cart value or total number of items across different products.
6.  **YAML Configuration (Part 1):** The system correctly parses YAML files structured similarly to the examples provided (`part1-cashier-system/config/`) and can load them from default or specified paths.
7.  **API Contract Assumes Mandatory Fields (Part 2):** Our API tests assume standard API behavior where mandatory fields are enforced by the API provider. For example, the contract test `Create Post - Missing Required Field` assumes the `title` field is mandatory for `POST /posts` as per a realistic API contract. We acknowledge that the `json-server` mock used for this challenge *permissively accepts* requests missing this field (returning 201 Created). Our test correctly expects an error status (e.g., 400 Bad Request) based on the assumed contract. Therefore, the test **intentionally fails** when run against the current permissive mock to highlight this deviation (see note under "Running the API Tests"). The test script includes logic to clean up the incorrectly created data to avoid impacting subsequent tests. A production-grade API would be expected to return the appropriate error status code.

## Part 2: API Testing

The [Postman collection](part2-api-testing/collection.json) includes tests for all specified endpoints:

-   GET, POST, PUT, DELETE operations for `/posts` and `/comments`
-   GET operation for `/profile`

Tests verify:

-   Response status codes (success and expected errors like 404)
-   Content-Type headers
-   Response body structure and data types (Schema Validation / Contract Testing)
-   Data content for key fields
-   Correct functioning of CRUD operations (Create, Read, Update, Delete) including state changes.

Our API tests follow **contract testing principles**, ensuring that the API adheres to expected contracts from a consumer's perspective. Each test validates not just basic functionality but the structure and format of responses.

### Implementation Notes and Assumptions (Part 2 Specific)

1.  **ID Handling:** The tests generally expect numeric IDs but are designed to handle string IDs from `json-server` where necessary.
2.  **API Structure:** Assumed the API generally follows RESTful conventions (correct HTTP methods for operations, standard status codes).
3.  **Error Handling:** Expected appropriate error codes for common issues (e.g., 404 for resources not found).
4.  **Data Relationships:** Assumed a logical relationship where comments belong to posts (`postId` field).
5.  **Database Reset on Start:** The `npm start` script now automatically resets `db.json` from `db.seed.json` before each server start, ensuring a clean state for every test run.
6.  **Mock Limitations:** As noted in Key Assumption #7, `json-server` does not enforce field requirements by default.

### Running the API Tests

#### Prerequisites:

-   Node.js (v14 or higher)
-   npm (v6 or higher)
-   Postman (latest version recommended)

#### Setup & Execution

1.  **Clone the Repository:**
    ```bash
    git clone <repository-url>
    cd <repository-folder-name>
    ```

2.  **Install Dependencies and Start the JSON Server:**
    ```bash
    cd part2-api-testing
    npm install
    # Create/edit db.seed.json if needed to define the desired initial state
    npm start
    ```
    The server will start at `http://localhost:3000` with a fresh copy of `db.seed.json` loaded into `db.json`.

3.  **Troubleshooting JSON Server**
    If you get `"command not found: json-server"` error:
    -   Make sure you've run `npm install` successfully in the `part2-api-testing` directory.
    -   Try using `npx`: `npx cp db.seed.json db.json && npx json-server --watch db.json --port 3000` (use `copy` instead of `cp` on Windows Command Prompt).
    -   Install JSON Server globally if needed: `npm install -g json-server` (less preferred). Note: you might also need `npm install -g shx` if using the cross-platform copy command mentioned in `package.json`.

4.  **Import the Collection into Postman:**
    -   Open Postman.
    -   Click "Import" button (top left).
    -   Select "File" > "Upload Files".
    -   Navigate to and select `part2-api-testing/collection.json`.
    -   Click "Import".

5.  **Configure Postman Environment (Essential):**
    -   Click on "Environments" in the left sidebar.
    -   Click the "+" button to create a new environment.
    -   Name it "Kantox QA Challenge" (or similar).
    -   Add a variable:
        -   **Variable:** `baseUrl`
        -   **Type:** default
        -   **Initial Value:** `http://localhost:3000`
        -   **Current Value:** `http://localhost:3000`
    -   Click "Save" (disk icon).
    -   **Crucially**: Select this newly created environment from the dropdown menu in the top right corner of the main Postman window before running the collection.

6.  **Run the Collection:**
    -   In the Collections sidebar, find "Kantox QA Challenge API Tests...".
    -   Click the three dots (⋮) next to the collection name and select "Run collection".
    -   In the Collection Runner window:
        -   Ensure the correct **Environment** ("Kantox QA Challenge") is selected.
        -   Ensure all requests are checked (or select specific ones/folders).
        -   Click the blue "Run Kantox QA Challenge API Tests..." button.

7.  **View and Analyze Test Results:**
    -   The Runner window shows pass/fail status for each test within each request.
    -   Green indicates pass, Red indicates fail.
    -   Click on a request name to see details of the request, response, and specific assertion results in the bottom pane.
    -   **NOTE: EXPECTED FAILURE** - Expect the `Negative Contract Tests` -> `Create Post - Missing Required Field` test to **FAIL** (showing red in the runner). This is *correct* and *expected* behavior for this challenge setup, as explained in Key Assumption #7. The mock server (json-server) incorrectly returns `201 Created` instead of an error status (like 400) when a required field ('title') is missing, thus violating the assumed API contract. The test correctly identifies this violation. Thanks to the database reset mechanism (Step 2), this intentional failure will not affect other tests in the run.

## BDD Specifications

BDD specifications in Gherkin format are included for both parts of the challenge:

-   [Cashier System Specifications](part1-cashier-system/bdd-specifications/cashier.feature)
-   [API Test Specifications](part2-api-testing/bdd-specifications/api.feature)

These specifications provide clear, business-readable test scenarios that serve as acceptance criteria for developers.

### BDD Approach Justification

-   **Clarity & Readability:** Gherkin's Given/When/Then structure makes test cases extremely easy to understand for both technical and non-technical stakeholders.
-   **Behavior Focus:** Encourages thinking about system behavior from a user/stakeholder perspective.
-   **Living Documentation Potential:** In a real project, these feature files could be directly linked to automation code using Cucumber, serving as executable specifications.
-   **Communication Bridge:** Helps bridge the gap between technical implementation and business requirements.