@TestOn("vm")

import "package:test/test.dart";
import 'package:laksaDart/src/crypto/schnorr.dart' as crypto;

main() {
  test('test with 1000 keypairs', () {
    for (int i = 0; i < 1000; i++) {
      String prvKey = crypto.generatePrivateKey();
      String pubKey = crypto.getPubKeyFromPrivateKey(prvKey);
      String address = crypto.getAddressFromPrivateKey(prvKey);

      expect(prvKey.length, equals(64));
      expect(pubKey.length, equals(66));
      expect(address.length, equals(40));
    }
  });
}
