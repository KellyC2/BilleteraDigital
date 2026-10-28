
Feature: Iniciar sesión

  Background:
    * url authUrl
    * header x-channel = 'POSTMAN'
    * header Content-Type = 'application/json'

  Scenario: Autenticar usuario registrado

    # phone y pin llegan desde el feature que llama
    Given path '/auth/v1/login'
    And request
    """
    {
      phone: '#(phone)',
      pin: '#(pin)'
    }
    """
    When method post
    Then status 200

    # Validar la autenticación
    * match response.token == '#string'
    * match response.user.id == '#string'

    # Datos que devolverá este feature
    * def token = response.token
    * assert token.length() > 30
    * def userId = response.user.id

    * print 'Login exitoso para usuario:', userId
