import 'package:laksadart/src/provider/index.dart';
import 'package:laksadart/src/messenger/index.dart';
import 'package:laksadart/src/account/index.dart';
import 'package:laksadart/src/transaction/index.dart';
import 'package:laksadart/src/contract/index.dart';
import 'package:laksadart/src/core/index.dart';
import 'package:laksadart/src/utils/validators.dart' as validators;

var DefaultConfig = new ZilliqaConfig({
  'Default': new ConfigItem(
      CHAIN_ID: 3,
      Network_ID: 'TestNet',
      nodeProviderUrl: 'http://localhost:4200'),
  'Staging': new ConfigItem(
      CHAIN_ID: 63,
      Network_ID: 'TestNet',
      nodeProviderUrl: 'https://staging-api.aws.z7a.xyz'),
  'DevNet': new ConfigItem(
      CHAIN_ID: 333,
      Network_ID: 'DevNet',
      nodeProviderUrl: 'https://dev-api.zilliqa.com'),
  'TestNet': new ConfigItem(
      CHAIN_ID: 2,
      Network_ID: 'TestNet',
      nodeProviderUrl: 'https://api.zilliqa.com'),
  'MainNet': new ConfigItem(
      CHAIN_ID: 1,
      Network_ID: 'MainNet',
      nodeProviderUrl: 'https://api.zilliqa.com')
});

class Laksa {
  String nodeUrl;
  String scillaUrl;
  String networkID;
  HttpProvider nodeProvider;
  HttpProvider scillaProvider;
  Messenger messenger;
  Blockchain blockchain;
  Wallet wallet;
  Contracts contracts;
  TransactionFactory transactions;
  ZilliqaConfig config;

  Laksa({String nodeUrl, String scillaUrl, String networkID}) {
    if (scillaUrl == null) {
      this.scillaUrl = nodeUrl;
    } else {
      this.scillaUrl = scillaUrl;
    }
    this.nodeUrl = nodeUrl;
    this.config = DefaultConfig;
    this.networkID = networkID ?? this.config.Default.Network_ID;

    if (validators.isUrl(this.nodeUrl) && validators.isUrl(this.scillaUrl)) {
      this.setNodeProvider(this.nodeUrl);
      this.setScillaProvider(this.scillaUrl);
      this.setMessenger();
      this.setBlockchain();
      this.setWallet();
      this.setTransactions();
      this.setContracts();
    } else {
      throw 'url is not correct';
    }
    this.setNetworkID(this.networkID);
  }

  void setNodeProvider(String url) {
    this.nodeUrl = url;
    this.nodeProvider = new HttpProvider(url);
    this.setMessenger();
  }

  void setScillaProvider(String url) {
    this.scillaUrl = url;
    this.scillaProvider = new HttpProvider(url);
    this.setMessenger();
  }

  void setMessenger() {
    this.messenger = new Messenger(
        nodeProvider: this.nodeProvider,
        scillaProvider: this.scillaProvider,
        config: this.config);
    this.setBlockchain();
    this.setWallet();
    this.setTransactions();
  }

  void setBlockchain() {
    this.blockchain = new Blockchain(this.messenger);
  }

  void setWallet() {
    this.wallet = new Wallet();
    this.wallet.setMessenger(this.messenger);
  }

  void setTransactions() {
    this.transactions = new TransactionFactory(this.messenger);
  }

  void setContracts() {
    this.contracts =
        new Contracts(messenger: this.messenger, wallet: this.wallet);
  }

  void setNetworkID(String id) {
    this.messenger.setNetworkID(id);
  }
}
