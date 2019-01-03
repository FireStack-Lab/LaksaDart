import 'dart:math';
import 'dart:convert';
import 'dart:async';
// import 'dart:typed_data';
// import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/utils/validators.dart' as validators;
import 'package:laksaDart/src/crypto/dartRandom.dart';
import 'package:laksaDart/src/account/wallet.dart';
import 'package:laksaDart/src/account/account.dart';

import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/provider/Middleware.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'Laksa.dart' show Laksa;

main() async {
  // var provider = new HttpProvider('https://staging-api.aws.zilliqa.com');
  // provider.middleware.response
  //     .use((data) => new RPCMiddleWare(data), match: '*');
  // // provider.middleware.response.use((Map data) => data['result'], match: '*');
  // var result = await provider.send(RPCMethod.GetNetworkId, '');
  // var messenger = new Messenger(nodeProvider: provider);

  // var result = await messenger.send(
  //     RPCMethod.GetBalance, '9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a');

  Laksa laksa = new Laksa('https://staging-api.aws.zilliqa.com');

  Account added = laksa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

  await added.updateBalance();

  print(added.balance);

  // Account acc = new Account(
  //     'e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930',
  //     laksa.messenger);

  // await acc.updateBalance();

  // print(acc.nonce);
  // var result = await laksa.blockchain.getBlockchainInfo();
  // print(result);
  // print(numbers.hexToInt(
  //     '34128120079449983507110620715836854069881601455496066315877882096931006377165'));

  // print(validators.isAddress('9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a'));
}
