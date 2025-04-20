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
    And I should save the first post id as "existingPostId" for later tests

  @posts @get
  Scenario: Get a specific post
    Given I know a valid post id stored as "existingPostId"
    When I send a GET request to "/posts/{existingPostId}"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an object with properties "id", "title" and "author"
    And the id in the response should match the requested "existingPostId"

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
    And I should save the id as "newPostId" for later tests

  @posts @update
  Scenario: Update an existing post
    Given I know a valid post id stored as "newPostId"
    And I have the following updated data:
      | title         | author         |
      | Updated Post  | Updated Author |
    When I send a PUT request to "/posts/{newPostId}" with this data
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should include the updated data
    And the id in the response should match the requested "newPostId"

  @posts @delete
  Scenario: Delete a post
    Given I know a valid post id stored as "newPostId"
    When I send a DELETE request to "/posts/{newPostId}"
    Then the response status code should be 200
    # JSON Server often returns empty object {} for successful DELETE
    And the response body should be an empty JSON object 
    And requesting the deleted post "/posts/{newPostId}" should return a 404 status code

  @posts @get @negative
  Scenario: Handle request for non-existent post
    When I send a GET request to "/posts/99999"
    Then the response status code should be 404

  @posts @create @negative
  Scenario: Create a post with missing required field
    Given I have the following incomplete data for a new post:
      | author      |
      | Bad Author  |
      # Missing 'title' which we assume is required by the contract schema
    When I send a POST request to "/posts" with this data
    # JSON Server might return 500 for schema violations or missing fields, 
    # but a well-designed API might return 400. We test for 500 based on JSON Server behavior.
    Then the response status code should be 500 
    And the response should indicate an error occurred

  @posts @update @negative
  Scenario: Update a non-existent post
    Given I have the following updated data:
      | title         | author         |
      | Ghost Post    | Ghost Author   |
    When I send a PUT request to "/posts/99999" with this data
    Then the response status code should be 404


  @comments @get
  Scenario: Get list of comments
    When I send a GET request to "/comments"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an array of objects
    # Assuming comments exist in db.json for this to pass robustly
    And each object should have the properties "id", "body" and "postId" 
    And if comments exist, I should save the first comment id as "existingCommentId" for later tests
    And if comments exist, I should save the first comment's postId as "existingCommentPostId" for later tests

  @comments @get
  Scenario: Get a specific comment
    Given I know a valid comment id stored as "existingCommentId"
    When I send a GET request to "/comments/{existingCommentId}"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an object with properties "id", "body" and "postId"
    And the id in the response should match the requested "existingCommentId"

  @comments @create
  Scenario: Create a new comment
    Given I know a valid post id stored as "existingPostId" 
    And I have the following data for a new comment:
      | body         | postId           |
      | Test Comment | {existingPostId} |
    When I send a POST request to "/comments" with this data
    Then the response status code should be 201
    And the content type should be "application/json"
    And the response should include the submitted data, matching "body" and "postId"
    And the response should include a generated "id"
    And I should save the id as "newCommentId" for later tests

  @comments @update
  Scenario: Update an existing comment
    Given I know a valid comment id stored as "newCommentId"
    And I have the following updated data:
      | body             |
      | Updated Comment  |
      # Assuming postId doesn't change on update, or test changing it if required
    When I send a PUT request to "/comments/{newCommentId}" with this data
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should include the updated "body"
    And the id in the response should match the requested "newCommentId"

  @comments @delete
  Scenario: Delete a comment
    Given I know a valid comment id stored as "newCommentId"
    When I send a DELETE request to "/comments/{newCommentId}"
    Then the response status code should be 200
    And the response body should be an empty JSON object
    And requesting the deleted comment "/comments/{newCommentId}" should return a 404 status code

  @comments @get @negative
  Scenario: Handle request for non-existent comment
    When I send a GET request to "/comments/99999"
    Then the response status code should be 404

  @profile @get
  Scenario: Get profile
    When I send a GET request to "/profile"
    Then the response status code should be 200
    And the content type should be "application/json"
    And the response should be an object with the property "name"