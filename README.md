# Automatización de Billetera Digital

Suite de pruebas de API implementada con Karate y JUnit 5.

## Requisitos

- Java 11 o superior.
- Maven 3.6 o superior.
- Servicios de autenticación, billetera y transacciones disponibles. Por defecto, la suite espera que estén en `localhost:4001`, `localhost:4002` y `localhost:4003`.

## Configuración

Las URLs se pueden definir mediante variables de entorno o propiedades JVM. Las propiedades JVM tienen prioridad:

| Servicio | Variable de entorno | Propiedad JVM | Valor predeterminado |
|---|---|---|---|
| Autenticación | `AUTH_URL` | `auth.url` | `http://localhost:4001` |
| Billetera | `WALLET_URL` | `wallet.url` | `http://localhost:4002` |
| Transacciones | `TRANSACTION_URL` | `transaction.url` | `http://localhost:4003` |

Ejemplo en PowerShell:

```powershell
$env:AUTH_URL = 'http://localhost:4001'
$env:WALLET_URL = 'http://localhost:4002'
$env:TRANSACTION_URL = 'http://localhost:4003'
mvn test
```

También se pueden pasar URLs como propiedades:

```powershell
mvn test "-Dauth.url=http://localhost:4001" "-Dwallet.url=http://localhost:4002" "-Dtransaction.url=http://localhost:4003"
```

## Ejecución

Desde la raíz del proyecto:

```powershell
mvn test
```

La prueba registra dos usuarios y requiere un backend de pruebas que acepte altas de usuarios con teléfonos nuevos. Maven guarda los resultados de Surefire en `target/surefire-reports` y el registro de Karate en `target/karate.log`.
