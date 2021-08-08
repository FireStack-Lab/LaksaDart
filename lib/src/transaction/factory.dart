import 'package:laksadart/src/core/zilliqa_module.dart';
import 'package:laksadart/src/messenger/messenger.dart';
import 'package:laksadart/src/transaction/transaction.dart';

class TransactionFactory implements ZilliqaModule {
  Messenger? _messenger;

  @override
  void set messenger(Messenger? messenger) => this._messenger = messenger;

  @override
  Messenger get messenger => this._messenger!;

  TransactionFactory(this._messenger);
  Transaction newTx(Map txParams) {
    return new Transaction(params: txParams, messenger: this.messenger);
  }
}
