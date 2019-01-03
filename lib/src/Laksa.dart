import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/messenger/Blockchain.dart';
import 'package:laksaDart/src/account/wallet.dart';
// import 'package:laksaDart/src/account/account.dart';
import 'package:laksaDart/src/utils/validators.dart' as validators;

class Laksa {
  String nodeUrl;
  String scillaUrl;
  HttpProvider nodeProvider;
  HttpProvider scillaProvider;
  Messenger messenger;
  Blockchain blockchain;
  Wallet wallet;

  Laksa(String nodeUrl, [String scillaUrl]) {
    if (scillaUrl == null) {
      this.scillaUrl = nodeUrl;
    } else {
      this.scillaUrl = scillaUrl;
    }
    this.nodeUrl = nodeUrl;

    if (validators.isUrl(this.nodeUrl) && validators.isUrl(this.scillaUrl)) {
      this.setNodeProvider(this.nodeUrl);
      this.setScillaProvider(this.scillaUrl);
      this.setMessenger();
      this.setBlockchain();
      this.setWallet();
    } else {
      throw 'url is not correct';
    }
  }

  void setNodeProvider(String url) {
    this.nodeUrl = url;
    this.nodeProvider = new HttpProvider(url);
  }

  void setScillaProvider(String url) {
    this.scillaUrl = url;
    this.scillaProvider = new HttpProvider(url);
  }

  void setMessenger() {
    this.messenger = new Messenger(
        nodeProvider: this.nodeProvider, scillaProvider: this.scillaProvider);
  }

  void setBlockchain() {
    this.blockchain = new Blockchain(this.messenger);
  }

  void setWallet() {
    this.wallet = new Wallet();
    this.wallet.setMessenger(this.messenger);
  }
}
