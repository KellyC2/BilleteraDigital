Feature: Flujo principal de la Billetera Digital
  Background:
    * url authUrl
    * header x-channel = 'POSTMAN'
    * header Content-Type = 'application/json'

    Scenario: Registro de usuarios
      # 1. Registrar emisor y receptor
      * def resultadoRegistro = call read('classpath:Autenticacion/RegistroUsuarios.feature')
      * def usuarios = resultadoRegistro.usuarios

      # Validar que sean usuarios diferentes
      * match usuarios.emisor.id != usuarios.receptor.id
      * match usuarios.emisor.phone != usuarios.receptor.phone

      # 2. Iniciar session del emsisor y obtener token de autenticación
      * def argsEmisor = { phone: '#(usuarios.emisor.phone)', pin: '#(usuarios.emisor.pin)' }
      * def resultadoLoginEmisor = call read('classpath:Autenticacion/IniciarSesion.feature') argsEmisor
      * def tokenEmisor = resultadoLoginEmisor.token

       # 3. Iniciar sesión del receptor
      * def argsReceptor = { phone: '#(usuarios.receptor.phone)', pin: '#(usuarios.receptor.pin)' }
      * def resultadoLoginReceptor = call read('classpath:Autenticacion/IniciarSesion.feature') argsReceptor
      * def tokenReceptor = resultadoLoginReceptor.token

      # 4. Depositar 1000 al emisor
      * def argsDepositoEmisor = {amount: 1000, expectedBalance: 1000 }
      * set argsDepositoEmisor.token = tokenEmisor
      * def resultadoDepositoEmisor = call read('classpath:Billetera/DepositarSaldo.feature') argsDepositoEmisor

      # 5. Depositar 1000 al receptor
      * def argsDepositoReceptor = { amount: 1000, expectedBalance: 1000 }
      * set argsDepositoReceptor.token = tokenReceptor
      * def resultadoDepositoReceptor = call read('classpath:Billetera/DepositarSaldo.feature') argsDepositoReceptor

      # 6. Consultar y guardar saldo inicial del emisor
      * def argsConsultaEmisor = {token: 'temporal'}
      * set argsConsultaEmisor.token = tokenEmisor
      * def consultaEmisor = call read('classpath:Billetera/ConsultarSaldo.feature') argsConsultaEmisor
      * def saldoInicialEmisor = consultaEmisor.saldoActual
      * match saldoInicialEmisor == 1000

      # 7. Consultar y guardar saldo inicial del receptor
      * def argsConsultaReceptor = {token: 'temporal'}
      * set argsConsultaReceptor.token = tokenReceptor
      * def consultaReceptor = call read('classpath:Billetera/ConsultarSaldo.feature') argsConsultaReceptor
      * def saldoInicialReceptor = consultaReceptor.saldoActual
      * match saldoInicialReceptor == 1000

      # 8. Conservar los datos para los siguientes pasos del flujo
      * def datosTransferencia =
        """
        {
          emisor: {
            id: '#(usuarios.emisor.id)',
            phone: '#(usuarios.emisor.phone)',
            token: '#(tokenEmisor)',
            saldoInicial: '#(saldoInicialEmisor)'
          },
          receptor: {
            id: '#(usuarios.receptor.id)',
            phone: '#(usuarios.receptor.phone)',
            token: '#(tokenReceptor)',
            saldoInicial: '#(saldoInicialReceptor)'
          }
        }
        """
      * print 'Datos preparados para la transferencia:', datosTransferencia



      # 9. Transferir dinero del emisor al receptor
      * def argsTransferencia = { amount: 450, description: 'Pago de Servicios' }
      * set argsTransferencia.token = tokenEmisor
      * set argsTransferencia.recipientId = usuarios.receptor.id
      * set argsTransferencia.categoryId = 'cat_food_1'

      * def resultadoTransferencia = call read('classpath:Transacciones/Transferir.feature') argsTransferencia


      # 10. Validar la transacción y guardar sus identificadores
      * match resultadoTransferencia.transactionStatus == 'COMPLETED'
      * match resultadoTransferencia.transactionId == '#string'
      * def codigoTransaccion = resultadoTransferencia.transactionId
      * def codigoReferencia = resultadoTransferencia.referenceCode
      * print 'Código de transacción:', codigoTransaccion
      * print 'Código de referencia:', codigoReferencia

      # 11. Consultar saldo del emisor después de la transferencia
      * def argsConsultaFinalEmisor = { token: 'temporal' }
      * set argsConsultaFinalEmisor.token = tokenEmisor
      * def consultaFinalEmisor = call read('classpath:Billetera/ConsultarSaldo.feature') argsConsultaFinalEmisor
      * def saldoFinalEmisor = consultaFinalEmisor.saldoActual


      # 12. Validar la disminución del saldo
      * def saldoEsperadoEmisor = saldoInicialEmisor - 450
      * match saldoFinalEmisor == saldoEsperadoEmisor
      * print 'Saldo inicial del emisor:', saldoInicialEmisor
      * print 'Saldo final del emisor:', saldoFinalEmisor

      # 13. Consultar saldo del receptor después de la transferencia
      * def argsConsultaActualReceptor = { token: 'temporal' }
      * set argsConsultaActualReceptor.token = tokenReceptor
      * def consultaActualReceptor = call read('classpath:Billetera/ConsultarSaldo.feature') argsConsultaActualReceptor
      * def saldoActualReceptor = consultaActualReceptor.saldoActual

      # 14. Validar incremento del saldo del receptor
      * def saldoEsperadoReceptor = saldoInicialReceptor + 450
      * match saldoActualReceptor == saldoEsperadoReceptor
      * print 'Saldo inicial receptor:', saldoInicialReceptor
      * print 'Saldo actual receptor:', saldoActualReceptor

      # 15. Consultar transacciones como administrador
      * def loginAdmin = call read('AdminService/InicioSesionAdministrador.feature')
      * def argsTransacciones =
          """
          {
            tokenAdmin: '#(loginAdmin.tokenAdmin)',
            idReceptor: '#(usuarios.receptor.id)',
            montoTransferencia: 450,
            codigoReferencia: '#(resultadoTransferencia.referenceCode)'
          }
          """
      * def consultaAdmin = call read('AdminService/ConsultarTransacciones.feature') argsTransacciones

