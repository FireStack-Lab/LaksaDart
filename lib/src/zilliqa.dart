import 'package:laksadart/src/provider/index.dart';
import 'package:laksadart/src/messenger/index.dart';
import 'package:laksadart/src/account/index.dart';
import 'package:laksadart/src/transaction/index.dart';
import 'package:laksadart/src/contract/index.dart';
import 'package:laksadart/src/utils/validators.dart' as validators;

class Zilliqa {
  String? nodeUrl;
  HttpProvider? nodeProvider;
  Messenger? _messenger;
  Blockchain? _blockchain;
  Wallet? _wallet;
  Contracts? _contracts;
  TransactionFactory? _transactions;

  Zilliqa({required String nodeUrl, HttpProvider? nodeProvider}) {
    this.nodeUrl = nodeUrl;
    this.nodeProvider =
        nodeProvider != null ? nodeProvider : HttpProvider(this.nodeUrl);
    this._messenger = Messenger(nodeProvider: this.nodeProvider);
    this._wallet = Wallet(this._messenger);
    this._blockchain = Blockchain(this._messenger);
    this._contracts =
        Contracts(messenger: this._messenger, wallet: this._wallet);
    this._transactions = TransactionFactory(this._messenger);
  }

  bool isValidNodeUrl(String? nodeUrl) =>
      nodeUrl != null && validators.isUrl(this.nodeUrl);

  TransactionFactory get transactions => this._transactions!;

  Blockchain get blockchain => this._blockchain!;

  Contracts get contracts => this._contracts!;

  Messenger get messenger => this._messenger!;

  Wallet get wallet => this._wallet!;
}
