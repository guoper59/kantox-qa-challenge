# language: en

@api_testing
Feature: Contract tests for REST API
  As a client application developer
  I want to verify that the API meets the expected contract
  To ensure my application can interact correctly with the API

  Background:
    Given the API is running at "http://localhost:3000"
    And I have access to posts, comments and profile endpoints

  @posts @get
  Scenario: Get list of posts
    When I send a GET request to "/posts"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an array of objects
    And each object should have the properties "id", "title" and "author"
    And I should save the first id for later tests

  @posts @get
  Scenario: Get a specific post
    Given I know a valid post id
    When I send a GET request to "/posts/{id}"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an object with properties "id", "title" and "author"
    And the id in the response should match the requested id

  @posts @create
  Scenario: Create a new post
    Given I have the following data for a new post:
      | title      | author      |
      | Test Post  | Test Author |
    When I send a POST request to "/posts" with this data
    Then the response status code should be 201
    And the content type should be "application/json"
    And the response should include the submitted data
    And the response should include a generated "id"
    And I should save the id for later tests

  @posts @update
  Scenario: Update an existing post
    Given I know a valid post id
    And I have the following updated data:
      | title         | author         |
      | Updated Post  | Updated Author |
    When I send a PUT request to "/posts/{id}" with this data
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should include the updated data
    And the id in the response should match the requested id

  @posts @delete
  Scenario: Delete a post
    Given I know a valid post id
    When I send a DELETE request to "/posts/{id}"
    Then the response status code should be 200
    And the response should be an empty object
    And requesting the deleted post should return a 404 status code

  @posts @error
  Scenario: Handle request for non-existent post
    When I send a GET request to "/posts/9999"
    Then the response status code should be 404

  @comments @get
  Scenario: Get list of comments
    When I send a GET request to "/comments"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an array of objects
    And each object should have the properties "id", "body" and "postId"
    And I should save the first id for later tests

  @comments @get
  Scenario: Get a specific comment
    Given I know a valid comment id
    When I send a GET request to "/comments/{id}"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an object with properties "id", "body" and "postId"
    And the id in the response should match the requested id

  @comments @create
  Scenario: Create a new comment
    Given I know a valid post id
    And I have the following data for a new comment:
      | body         | postId  |
      | Test Comment | {postId}|
    When I send a POST request to "/comments" with this data
    Then the response status code should be 201
    And the content type should be "application/json"
    And the response should include the submitted data
    And the response should include a generated "id"

  @comments @update
  Scenario: Update an existing comment
    Given I know a valid comment id
    And I have the following updated data:
      | body             |
      | Updated Comment  |
    When I send a PUT request to "/comments/{id}" with this data
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should include the updated data
    And the id in the response should match the requested id

  @comments @delete
  Scenario: Delete a comment
    Given I know a valid comment id
    When I send a DELETE request to "/comments/{id}"
    Then the response status code should be 200
    And the response should be an empty object
    And requesting the deleted comment should return a 404 status code

  @profile @get
  Scenario: Get profile
    When I send a GET request to "/profile"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an object with the property "name"
