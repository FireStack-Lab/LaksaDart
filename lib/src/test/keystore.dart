@TestOn("vm")

import 'dart:convert';
import 'dart:io';
import "package:test/test.dart";
import "package:laksaDart/src/account/account.dart";

main() {
  test("Test decrypt KeyStores", () async {
    File schnorrVector = new File('./fixtures/keystores.json');

    await schnorrVector
        .readAsString()
        .then((fileContents) => jsonDecode(fileContents))
        .then((keystoreFixture) async {
      for (int i = 0; i < keystoreFixture.length; i++) {
        var privateKey = keystoreFixture[i]['privateKey'];
        var passphrase = keystoreFixture[i]['passphrase'];
        var keystore = json.encode(keystoreFixture[i]['keystore']);
        Account account = await Account.fromFile(keystore, passphrase);
        expect(account.privateKey, equals(privateKey));
      }
    });
  });
  test("Test encrypt KeyStores", () async {
    File schnorrVector = new File('./fixtures/keystores.json');

    await schnorrVector
        .readAsString()
        .then((fileContents) => jsonDecode(fileContents))
        .then((keystoreFixture) async {
      for (int i = 0; i < keystoreFixture.length; i++) {
        var privateKey = keystoreFixture[i]['privateKey'];
        var passphrase = keystoreFixture[i]['passphrase'];
        Account testAccount = new Account(privateKey);
        String encrypted = await testAccount.toFile(passphrase);
        expect(json.decode(encrypted)['mac'],
            equals(keystoreFixture[i]['keystore']['mac']));
      }
    });
  });
}
