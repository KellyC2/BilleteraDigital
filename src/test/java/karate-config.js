function fn() {
  var System = Java.type('java.lang.System');

  function getUrl(propertyName, environmentName, defaultUrl) {
    var value = System.getProperty(propertyName);
    if (!value) {
      value = System.getenv(environmentName);
    }
    return (value || defaultUrl).replace(/\/+$/, '');
  }

  var config = {
    authUrl: getUrl('auth.url', 'AUTH_URL', 'http://134.209.211.10:4001'),
    walletUrl: getUrl('wallet.url', 'WALLET_URL', 'http://134.209.211.10:4002'),
    transactionUrl: getUrl('transaction.url', 'TRANSACTION_URL', 'http://134.209.211.10:4003'),
    adminServiceUrl: getUrl('admin.url', 'ADMIN_URL', 'http://134.209.211.10:4004')
  };

  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);

  return config;
}
