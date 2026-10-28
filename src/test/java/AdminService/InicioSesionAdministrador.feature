Feature: Login de administrador
  Background:
  * url adminServiceUrl
  * header x-channel = 'POSTMAN'

  Scenario: Obtener token administrativo
    Given path '/admin/v1/login'
    And request
      """
      {
        "username": "admin",
        "password": "superpassword"
      }
      """
    When method post
    Then status 200
    And match response.token == '#string'
    * def tokenAdmin = response.token