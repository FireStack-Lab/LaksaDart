import 'package:laksaDart/src/core/ZilliqaModule.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/transaction/transaction.dart';

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
