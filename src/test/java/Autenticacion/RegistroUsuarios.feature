
Feature: Registrar emisor y receptor

  Background:
    * url authUrl
    * header x-channel = 'POSTMAN'
    * header Content-Type = 'application/json'

  Scenario: Registrar ambos usuarios

    # Generar celulares aleatorios
    * def generarCelular =
    """
    function() {
      var ThreadLocalRandom = Java.type('java.util.concurrent.ThreadLocalRandom');
      return '9' + ThreadLocalRandom.current().nextInt(10000000, 100000000);
    }
    """

    * def pinUsuario = '123456'
    * def celularEmisor = generarCelular()
    * def celularReceptor = generarCelular()
    * assert celularEmisor != celularReceptor

    # Registrar emisor
    * def emisor =
    """
    {
      phone: '#(celularEmisor)',
      fullName: 'Emisor Prueba',
      email: '#(celularEmisor)@test.com',
      pin: '#(pinUsuario)'
    }
    """

    Given url authUrl
    And path '/auth/v1/register'
    And header x-channel = 'POSTMAN'
    And header Content-Type = 'application/json'
    And request emisor
    When method post
    Then status 201

    * match response.user.status == 'ACTIVE'
    * match response.user.id == '#string'
    * def idEmisor = response.user.id

    # Registrar receptor
    * def receptor =
    """
    {
      phone: '#(celularReceptor)',
      fullName: 'Receptor Prueba',
      email: '#(celularReceptor)@test.com',
      pin: '#(pinUsuario)'
    }
    """

    Given url authUrl
    And path '/auth/v1/register'
    And header x-channel = 'POSTMAN'
    And header Content-Type = 'application/json'
    And request receptor
    When method post
    Then status 201

    * match response.user.status == 'ACTIVE'
    * match response.user.id == '#string'
    * def idReceptor = response.user.id

    # Validar que sean usuarios diferentes
    * match idEmisor != idReceptor

    # Datos que devolverá este feature al principal
    * def usuarios =
    """
    {
      emisor: {
        phone: '#(celularEmisor)',
        id: '#(idEmisor)',
        pin: '#(pinUsuario)'
      },
      receptor: {
        phone: '#(celularReceptor)',
        id: '#(idReceptor)',
        pin: '#(pinUsuario)'
      }
    }
    """

    * print 'Usuarios registrados:', usuarios
