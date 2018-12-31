import 'dart:math';
import 'dart:convert';
import 'dart:async';
// import 'dart:typed_data';
// import 'package:crypto/crypto.dart';
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/crypto/dartRandom.dart';
import 'package:laksaDart/src/account/wallet.dart';
import 'package:laksaDart/src/account/account.dart';

main() async {
  var wallet = new Wallet();

  wallet
    ..create()
    ..create()
    ..create()
    ..add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930')
    ..setDefaultAccount('9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a');
  var encryptedAcc = await wallet.encryptAccount(
      '9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a', '111');

  wallet.remove('9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a');

  print(wallet.defaultAccount);
  // ..encryptAccount('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930', '111');
}
