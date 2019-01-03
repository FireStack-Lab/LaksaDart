import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/core/ZilliqaModule.dart';
import 'Messenger.dart';

class Blockchain implements ZilliqaModule<Messenger, void> {
  Messenger messenger;

  Blockchain(this.messenger);

  Future getBalance({String address}) async {
    return await this.messenger.send(RPCMethod.GetBalance, address);
  }

  Future getBlockchainInfo() async {
    return await this.messenger.send(RPCMethod.GetBlockchainInfo, '');
  }

  void setMessenger(Messenger messenger) {
    this.messenger = messenger;
  }
}
