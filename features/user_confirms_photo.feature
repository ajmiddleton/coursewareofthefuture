Feature: Student authentication
  As a user
  I want others to see an accurate picture of me

  - Require confirmed picture
  - Accept URL or uploaded picture

  Scenario: Student must confirm their photo
    Given I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    And I go to the homepage
    Then I should see "You must use a photo of your face"
    And I should not see "This is a picture of me."

  Scenario: Student with confirmed photo doesn't need to confirm
    Given the following student:
      | github_username | joe |
    And I am signed in as that student
    When I go to the homepage
    Then I should not see "You must use a photo of your face"

  Scenario: Student confirms photo
    Given I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    And I go to the homepage
    And I press "This is a picture of me."
    Then I should see "Your profile photo has been updated."
    When I go to the homepage
    Then I should not see "You must use a photo of your face"

  Scenario: Student changes photo by url
    Given I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    Then my photo should be "joe.jpeg"
    When I fill in "Web address for your photo" with "http://example.com/image.png"
    And I press "Submit"
    Then I should see "Your profile photo has been updated."
    When I go to the homepage
    Then my photo should be "image.png"

  Scenario: Student changes photo by upload
    Given I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    Then my photo should be "joe.jpeg"
    When I upload a file "github.png"
    And I press "Submit"
    Then I should see "Your profile photo has been updated."
    When I go to the homepage
    Then my photo should be "github.png"

  Scenario: Student changes photo by upload and url
    Given I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    And I go to the homepage
    Then my photo should be "joe.jpeg"
    When I upload a file "github.png"
    When I fill in "Web address for your photo" with "http://example.com/image.png"
    And I press "Submit"
    Then I should see "Your profile photo has been updated."
    When I go to the homepage
    Then my photo should be "github.png"