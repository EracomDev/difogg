import 'dart:js' as js;

void main() {
  generateTronAddress();
}

void generateTronAddress() {
  final jsTronWeb = js.context['TronWeb'];

  if (jsTronWeb != null) {
    final jsInstance = jsTronWeb.newInstance([]);
    final jsAddress = jsInstance.callMethod('address');
    final jsPrivateKey = jsInstance.callMethod('address', ['privateKey']);

    final tronAddress = jsAddress.callMethod('generate');
    final privateKey = jsPrivateKey.callMethod('fromRandom');

    print('TRON Address: $tronAddress');
    print('Private Key: $privateKey');
  } else {
    print('TronWeb library not found.');
  }
}
