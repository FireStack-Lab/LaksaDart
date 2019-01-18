import 'package:laksadart/src/core/ZilliqaModule.dart';
import 'package:laksadart/src/messenger/Messenger.dart';
import 'package:laksadart/src/transaction/transaction.dart';

class TransactionFactory implements ZilliqaModule<Messenger, void> {
  Messenger messenger;
  void setMessenger(Messenger data) {
    this.messenger = data;
  }

  TransactionFactory(this.messenger);
  Transaction newTx(Map txParams) {
    return new Transaction(params: txParams, messenger: this.messenger);
  }
}
