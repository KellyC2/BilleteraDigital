
Feature: Transferencia entre usuarios

  Scenario: Transferir dinero a otro usuario
    * def token = __arg.token
    * def recipientId = __arg.recipientId
    * def amount = __arg.amount
    * def description = __arg.description
    * def categoryId = __arg.categoryId

    Given url transactionUrl
    And path '/transaction/v1/transfer'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And request
      """
      {
        recipientId: '#(recipientId)',
        amount: '#(amount)',
        description: '#(description)',
        categoryId: '#(categoryId)'
      }
      """
    When method post
    Then status 200

    * match response.transactionId == '#string'
    * match response.referenceCode == '#string'
    * match response.status == 'COMPLETED'
    * match response.message == 'Transferencia realizada con éxito'


    * def transactionId = response.transactionId
    * def referenceCode = response.referenceCode
    * def transactionStatus = response.status
    * def transactionMessage = response.message
    * print 'Transferencia exitosa:', response
