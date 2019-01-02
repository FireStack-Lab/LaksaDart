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
import 'package:laksaDart/src/provider/Middleware.dart';

main() async {
  var provider = new HttpProvider('https://staging-api.aws.zilliqa.com');
  provider.middleware.response
      .use((data) => new RPCMiddleWare(data), match: '*');
  // provider.middleware.response.use((Map data) => data['result'], match: '*');
  var result = await provider.send(RPCMethod.GetNetworkId, '');
  print(result);
}
