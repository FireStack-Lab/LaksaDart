import 'package:laksaDart/src/crypto/schnorr.dart' as crypto;

main() {
  for (int i = 0; i < 10000; i++) {
    String prvKey = crypto.generatePrivateKey();
    String pubKey = crypto.getPubKeyFromPrivateKey(prvKey);
    String address = crypto.getAddressFromPrivateKey(prvKey);
    if (prvKey.length != 64) {
      print({'prvLength': prvKey.length});
      break;
    } else {
      print({'prvKey': prvKey, 'pubKey': pubKey, 'address': address});
    }
  }
}
