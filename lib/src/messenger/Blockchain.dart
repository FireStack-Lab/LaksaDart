import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/core/ZilliqaModule.dart';
import 'package:laksaDart/src/provider/Middleware.dart';
import 'Messenger.dart';

class Blockchain implements ZilliqaModule<Messenger, void> {
  Messenger messenger;
  Blockchain(this.messenger);
  void setMessenger(Messenger messenger) {
    this.messenger = messenger;
  }

  Future getBalance({String address}) async {
    // this.messenger.setMiddleware((data) => new RPCMiddleWare(data).raw,
    //     match: RPCMethod.GetBalance);
    return await this.messenger.send(RPCMethod.GetBalance, address);
  }

  Future getBlockchainInfo() async {
    return await this.messenger.send(RPCMethod.GetBlockchainInfo);
  }

  Future getDSBlock({int blockNum}) async {
    return await this.messenger.send(RPCMethod.GetDSBlock, blockNum.toString());
  }

  Future getLatestDSBlock() async {
    return await this.messenger.send(RPCMethod.GetLatestDSBlock);
  }

  Future getNumDSBlocks() async {
    return await this.messenger.send(RPCMethod.GetNumDSBlocks);
  }

  Future getDSBlockRate() async {
    return await this.messenger.send(RPCMethod.GetDSBlockRate);
  }

  Future getDSBlockListing({int max}) async {
    return await this.messenger.send(RPCMethod.DSBlockListing, max);
  }

  Future getTxBlock({int blockNum}) async {
    return await this.messenger.send(RPCMethod.GetTxBlock, blockNum.toString());
  }

  Future getLatestTxBlock() async {
    return await this.messenger.send(RPCMethod.GetLatestTxBlock);
  }

  Future getNumTxBlocks() async {
    return await this.messenger.send(RPCMethod.GetNumTxBlocks);
  }

  Future getTxBlockRate() async {
    return await this.messenger.send(RPCMethod.GetTxBlockRate);
  }

  Future getTxBlockListing({int max}) async {
    return await this.messenger.send(RPCMethod.TxBlockListing, max);
  }

  Future getNumTransactions() async {
    return await this.messenger.send(RPCMethod.GetNumTransactions);
  }

  Future getTransactionRate() async {
    return await this.messenger.send(RPCMethod.GetTransactionRate);
  }

  Future getCurrentMiniEpoch() async {
    return await this.messenger.send(RPCMethod.GetCurrentMiniEpoch);
  }

  Future getCurrentDSEpoch() async {
    return await this.messenger.send(RPCMethod.GetCurrentDSEpoch);
  }

  Future getPrevDifficulty() async {
    return await this.messenger.send(RPCMethod.GetPrevDifficulty);
  }

  Future getPrevDSDifficulty() async {
    return await this.messenger.send(RPCMethod.GetPrevDSDifficulty);
  }

  Future getRecentTransactions() async {
    return await this.messenger.send(RPCMethod.GetRecentTransactions);
  }

  Future getNumTxnsTxEpoch({int epoch}) async {
    return await this.messenger.send(RPCMethod.GetNumTxnsTxEpoch, epoch);
  }

  Future getNumTxnsDSEpoch({int epoch}) async {
    return await this.messenger.send(RPCMethod.GetNumTxnsDSEpoch, epoch);
  }

  Future getMinimumGasPrice() async {
    return await this.messenger.send(RPCMethod.GetMinimumGasPrice);
  }

  // TODO: getTransaction
  // TODO: completeTransaction
  // TODO: createTransaction
}
