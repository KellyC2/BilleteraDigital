
Feature: Consultar historial global de transacciones

  Background:
    * url adminServiceUrl
    * header x-channel = 'POSTMAN'

  Scenario: Validar transacción realizada como administrador
    Given path '/admin/v1/transactions'
    And header Authorization = 'Bearer ' + tokenAdmin
    When method get
    Then status 200
    And match response == '#[]'

    * def transacciones = response

    # Buscar el ingreso correspondiente al receptor
    * def ingresosReceptor = karate.filter(transacciones, function(x){ return x.userId == idReceptor && x.type == 'INCOME' && x.amount == montoTransferencia && x.referenceCode == codigoReferencia })

    # Validar que exista exactamente una coincidencia
    * match ingresosReceptor == '#[1]'

    # Validar los datos de la transacción
    * match ingresosReceptor[0].userId == idReceptor
    * match ingresosReceptor[0].type == 'INCOME'
    * match ingresosReceptor[0].amount == montoTransferencia
    * match ingresosReceptor[0].referenceCode == codigoReferencia

    * print 'Transacción validada por el administrador:', ingresosReceptor[0]

