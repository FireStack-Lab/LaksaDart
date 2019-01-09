import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
// import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/utils/validators.dart' as validators;
import 'package:laksaDart/src/crypto/dartRandom.dart';
import 'package:laksaDart/src/account/wallet.dart';
import 'package:laksaDart/src/account/account.dart';
import 'package:laksaDart/src/account/address.dart';

import 'package:laksaDart/src/utils/unit.dart' as unit;

import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/provider/Middleware.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/transaction/transaction.dart';
import 'package:laksaDart/src/contract/contract.dart';
import 'package:laksaDart/src/contract/testScilla.dart';
import 'package:laksaDart/src/contract/util.dart';

import 'Laksa.dart' show Laksa;

main() async {
  var laksa = new Laksa('https://api.zilliqa.com');
  laksa.setScillaProvider('https://scilla-runner.zilliqa.com');

  var acc = laksa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');
}
