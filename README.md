


# QA Engineer Challenge
Thank you for your interest in Kantox, we are delighted you are considering joining our team.

Next, you will find two different tasks. Please, provide a link to your repository with the solution.

It would be nice to have the assignment ready within 5 natural days of inbox reception.

If you have any doubt or need any help, please do not hesitate to contact us.

Thank you for your time and good luck!

---

## Part 1: Test case creation

Following, there is the test we propose to developers. As the QA member of the team you have to design the right and precise test cases to give the team the confidence of a good test coverage. There are no limits nor restrictions, just express yourself.

### Cashier System
Simple cashier function that adds products to a cart and displays the total price. The following products are registered:

| Product Code  | Name         |  Price |
|---            |---           |---     |
| GR1           | Green Tea    | £3.11  |
| SR1           | Strawberries | £5.00  |
| CF1           |  Coffee      | £11.23 | 

**Special Rules**
* Buy one get one free
* Buy > N products, pay X price per product
* Buy > N products, pay X% of the original price

**Products and Discount Rules**
The project doesn't connect to a database, it reads both the products and rules from a YAML file.
The default location of the file is priv/assets/products.yml and priv/assets/rules.yml, this can be changed in the Configuration.
Currently there are only 3 types of configurable discount rules:
* FreeRule (buy N get N free)
* ReducedPriceRule (buy more than N pay a different price)
* FractionPriceRule (buy more than N, pay a percentage of the original price)

---

## Part 2: API Test

This project sets up a test API using Node.js and JSON Server. Candidates should create a Postman collection with tests for this API.

### Prerequisites

- Node.js (v14 or higher)
- npm (v6 or higher)

### Installation Instructions


1. Install the dependencies:
    ```sh
    npm install
    ```

2. Start the JSON server:
    ```sh
    npm start
    ```

The server will start at `http://localhost:3000`.

### Instructions for Candidates

1. Create a Postman collection with tests for the following endpoints:
    - `GET /posts`
    - `GET /posts/{id}`
    - `POST /posts`
    - `PUT /posts/{id}`
    - `DELETE /posts/{id}`
    - `GET /comments`
    - `GET /comments/{id}`
    - `POST /comments`
    - `PUT /comments/{id}`
    - `DELETE /comments/{id}`
    - `GET /profile`

2. Save the Postman collection to a file named `collection.json` and add it to the repository.


