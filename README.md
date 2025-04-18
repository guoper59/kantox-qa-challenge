# Kantox QA Engineer Challenge Solution

This repository contains a solution for the Kantox QA Engineer Challenge with comprehensive test cases and API tests.

## Repository Structure

```
kantox-qa-challenge/
├── README.md                           # Main documentation with detailed instructions
├── part1-cashier-system/               # Cashier system tests
│   ├── test-cases.md                   # Detailed test cases with links
│   ├── test-execution-plan.md          # Prioritized execution plan
│   ├── bdd-specifications/             # BDD specifications in Gherkin
│   │   └── cashier.feature             # Cashier system scenarios
│   └── config/                         # Example configuration
│       ├── products.yml                # Sample products
│       └── rules.yml                   # Sample discount rules
│
└── part2-api-testing/                  # API tests
    ├── collection.json                 # Postman collection 
    ├── bdd-specifications/             # BDD specifications in Gherkin
    │   └── api.feature                 # API test scenarios 
    ├── db.json                         # Sample database
    └── package.json                    # Dependencies for JSON server
```

## Overall QA Strategy & Justifications

Our approach follows industry best practices, emphasizing:

- **Risk-Based Testing:** Focusing tests on key functional areas (discount rule logic, API CRUD operations) and potential weaknesses (boundaries, rule interactions).
- **Requirements-Driven Design:** Ensuring all specified functionalities and endpoints are covered.
- **Structured Test Design Techniques:** Utilizing formal methods (EP, BVA, decision tables) for systematic coverage.
- **Clear Documentation & Justification:** Explaining the *why* behind the approach and assumptions.
- **Adherence to ISTQB Principles:** Applying standard terminology and concepts throughout the test documentation.

## Part 1: Cashier System Test Cases

The [test cases](part1-cashier-system/test-cases.md) cover:

- Basic cart operations (add, update, remove products)
- Discount rule application:
  - Buy one get one free (FreeRule)
  - Reduced price for bulk purchases (ReducedPriceRule)
  - Percentage discounts (FractionPriceRule)
- Configuration handling and file loading
- Edge cases and error conditions

A [test execution plan](part1-cashier-system/test-execution-plan.md) prioritizes these tests for efficient implementation.

### Test Design Techniques Used

- **Equivalence Partitioning (EP):** Dividing input quantities into valid and invalid classes
- **Boundary Value Analysis (BVA):** Testing at and around discount thresholds (N-1, N, N+1)
- **Decision Table Thinking:** Ensuring combinations of products and quantities are covered
- **State Transition Testing:** Used for cart operations (empty → add → update → remove)
- **Gherkin (BDD Syntax):** Used to present test cases in a clear, business-readable format

### Key Assumptions

1. **Rule Interaction:** When multiple discount rules could apply to a product, the system applies the most beneficial discount for the customer.
2. **Rule Thresholds:** "Buy > N" means quantity N+1 or more triggers the rule. "Buy N get M free" triggers when quantity is >= N.
3. **Rounding Behavior:** For FractionPriceRule, percentage calculations resulting in fractional currency are rounded to 2 decimal places **per item** before summing the total (e.g., £11.23 * 2/3 = £7.4866... rounded to £7.49 per item).
4. **Input Validation:** The system validates inputs (rejects negative quantities, non-existent products).
5. **Product-Level Discounts:** Discounts are calculated at the product level, not the cart level.
6. **YAML Configuration:** Files follow the structure shown in our sample files.

## Part 2: API Testing

The [Postman collection](part2-api-testing/collection.json) includes tests for all specified endpoints:

- GET, POST, PUT, DELETE operations for posts and comments
- GET operation for profile

Tests verify:
- Response status codes
- Content types
- Data structure and content
- CRUD operations function correctly

Our API tests follow contract testing principles, ensuring that the API adheres to expected contracts. Each test validates not just functionality but the structure and format of responses.

### Implementation Notes and Assumptions

1. **ID Handling:** The tests work with numeric IDs in the db.json file.
2. **API Structure:** We assume the API follows RESTful conventions and returns standardized response formats.
3. **Error Handling:** We expect the API to return appropriate error codes (e.g., 404 for resources not found).
4. **Data Relationships:** We assume there is a relationship between posts and comments (comments have a postId that references a post).
5. **State Persistence:** We assume API changes persist during server runtime due to the `--watch` flag, enabling state verification tests. Restarting the server resets state.

### Running the API Tests

#### Prerequisites:
- Node.js (v14 or higher)
- npm (v6 or higher)
- Postman (latest version recommended)

#### Setup & Execution

1. **Clone the Repository:**
   ```bash
   git clone <repository-url>
   cd kantox-qa-challenge
   ```

2. **Install Dependencies and Start the JSON Server:**
   ```bash
   cd part2-api-testing
   npm install
   npm start
   ```
   The server will start at http://localhost:3000.

3. **Troubleshooting JSON Server**

   If you get "command not found: json-server" error:
   - Make sure you've run `npm install` in the part2-api-testing directory
   - Try using npx: `npx json-server --watch db.json --port 3000`
   - Install JSON Server globally if needed: `npm install -g json-server`

4. **Import the Collection into Postman:**
   - Open Postman
   - Click "Import" button in the top left corner
   - Select "File" > "Choose Files"
   - Navigate to and select `part2-api-testing/collection.json`
   - Click "Import"

5. **Configure Postman Environment (Recommended):**
   - Click on "Environments" in the left sidebar
   - Click the "+" button to create a new environment
   - Name it "Kantox QA Challenge"
   - Add a variable named "baseUrl" with value "http://localhost:3000"
   - Click "Save"
   - **Important**: Select the environment from the dropdown in the top right corner of Postman

6. **Run the Collection:**
   - In the Collections sidebar, find "Kantox QA Challenge API Tests"
   - Click the "▶️" (Run) button or the three dots (⋮) next to the collection name and select "Run collection"
   - In the Collection Runner window that opens:
     - Ensure all requests are selected
     - Select the environment you created
     - Click the blue "Run" button

7. **View and Analyze Test Results:**
   - Each request will execute with its tests
   - Green tests indicate passes, red indicate failures
   - You'll see a summary showing test counts and response times
   - Examine individual tests by clicking on requests and viewing the "Tests" and "Test Results" tabs

## BDD Specifications

BDD specifications in Gherkin format are included for both parts of the challenge:
- [Cashier System Specifications](part1-cashier-system/bdd-specifications/cashier.feature)
- [API Test Specifications](part2-api-testing/bdd-specifications/api.feature)

These specifications provide clear, business-readable test scenarios that serve as acceptance criteria for developers. Each specification corresponds directly to test cases in the test case document and test assertions in the Postman collection.

### BDD Approach Justification

- **Clarity & Readability:** Gherkin's Given/When/Then structure makes test cases extremely easy to understand for both technical and non-technical stakeholders.
- **Behavior Focus:** Encourages thinking about system behavior from a user/stakeholder perspective.
- **Living Documentation Potential:** In a real project, these feature files could be directly linked to automation code using Cucumber, serving as executable specifications.
- **Communication Bridge:** Helps bridge the gap between technical implementation and business requirements.
