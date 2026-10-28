
Feature: Depositar saldo en una billetera

  Scenario: Depositar fondos y validar el resultado

    * print 'Argumentos recibidos:', karate.pretty(__arg)
    * def token = __arg.token
    * def amount = __arg.amount
    * def expectedBalance = __arg.expectedBalance

    * match token == '#string'
    * assert token.length > 30

    * url walletUrl
    * header x-channel = 'POSTMAN'
    * assert token.length() > 30
    * header Authorization = 'Bearer ' + token


    Given path '/wallet/v1/deposit'
    And request { amount: '#(amount)' }
    When method post
    Then status 200

    * match response.success == true
    * match response.newBalance == '#number'
    * match response.newBalance == expectedBalance

    * def saldoDepositado = response.newBalance
