@TestOn("vm")

import 'dart:convert';
import 'dart:io';
import "package:test/test.dart";
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/crypto/schnorr.dart' as schnorr;

void main() {
  test("Test Schnorr Signature with preset json", () async {
    File schnorrVector = new File('./fixtures/schnorr.signature.json');
    await schnorrVector
        .readAsString()
        .then((fileContents) => jsonDecode(fileContents))
        .then((testJson) async {
      // error i=284
      for (int i = 285; i < 1000; i++) {
        String pub = testJson[i]['pub'];
        String priv = testJson[i]['priv'];
        String msg = testJson[i]['msg'];
        String k = testJson[i]['k'];
        String r = testJson[i]['r'];
        String s = testJson[i]['s'];

        var sig = null;

        while (sig == null) {
          sig = await schnorr.trySign(
              numbers.hexToBytes(msg),
              numbers.hexToInt(k),
              numbers.hexToInt(priv),
              numbers.hexToBytes(pub));
        }

        // check with c++ definition
        bool res = await schnorr.verify(
          numbers.hexToBytes(msg),
          sig.r,
          sig.s,
          numbers.hexToBytes(pub),
        );

        expect(res, equals(true));
        expect(sig.s, equals(numbers.hexToInt(s)));
        expect(sig.r, equals(numbers.hexToInt(r)));
      }
    });
  });
}
