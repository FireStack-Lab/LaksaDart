import 'dart:math';
import 'dart:convert';
import 'dart:async';
// import 'dart:typed_data';
// import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/crypto/dartRandom.dart';
import 'package:laksaDart/src/account/wallet.dart';
import 'package:laksaDart/src/account/account.dart';

import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/provider/net.dart';

main() async {
  var provider = new HttpProvider('https://staging-api.aws.zilliqa.com');
  provider.middleware.response.use((Map data) {
    if (data['error'] != null) {
      return data['error'];
    } else if (data['result'] != null) {
      return data['result'];
    }
  }, match: '*');
  // provider.middleware.response.use((Map data) => data['result'], match: '*');
  var result = await provider.send(new RPCMethod().GetNetworkId, '');
  print(result);
}
