import 'dart:convert';
import 'dart:io';
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/crypto/schnorr.dart' as schnorr;

void main() {
  File schnorrVector = new File('./fixtures/schnorr.signature.json');
  schnorrVector
      .readAsString()
      .then((fileContents) => jsonDecode(fileContents))
      .then((testJson) {
    for (int i = 0; i < 1; i++) {
      String pub = testJson[i]['pub'];
      String priv = testJson[i]['priv'];
      String msg = testJson[i]['msg'];
      String k = testJson[i]['k'];
      String r = testJson[i]['r'];
      String s = testJson[i]['s'];

      var sig = null;

      while (sig == null) {
        sig = schnorr.trySign(numbers.hexToBytes(msg), numbers.hexToInt(k),
            numbers.hexToInt(priv), numbers.hexToBytes(pub));
      }
      // print(numbers.hexToInt(k));

      // check with c++ definition
      bool res = schnorr.verify(
        numbers.hexToBytes(msg),
        sig.r,
        sig.s,
        numbers.hexToBytes(pub),
      );
      if (res == false ||
          sig.s != numbers.hexToInt(s) ||
          sig.r != numbers.hexToInt(r)) {
        print('ahhhhhhhhh');
      }
    }
  });
}
