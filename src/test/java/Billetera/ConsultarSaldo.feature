
Feature: Consultar saldo de billetera

  Scenario: Consultar y validar saldo actual

    * def token = __arg.token
    * url walletUrl
    * header x-channel = 'POSTMAN'
    * header Authorization = 'Bearer ' + token

    Given path '/wallet/v1/balance'
    When method get
    Then status 200

    * match response.balance == '#number'
    * match response.currency == 'USD'
    * def saldoActual = response.balance
