import 'dart:convert';
import 'package:laksadart/src/provider/net.dart';
import 'package:laksadart/src/core/ZilliqaModule.dart';
import 'package:laksadart/src/provider/Middleware.dart';
import 'package:laksadart/src/transaction/transaction.dart';
import 'package:laksadart/src/transaction/api.dart';
import 'Messenger.dart';

class Blockchain implements ZilliqaModule<Messenger, void> {
  Messenger messenger;
  Blockchain(this.messenger);
  void setMessenger(Messenger messenger) {
    this.messenger = messenger;
  }

  Future<RPCMiddleWare> getBalance({String address}) async {
    this.messenger.setMiddleware((data) => new RPCMiddleWare(data).raw,
        match: RPCMethod.GetBalance);
    return await this.messenger.send(RPCMethod.GetBalance, address);
  }

  Future<RPCMiddleWare> getBlockchainInfo() async {
    return await this.messenger.send(RPCMethod.GetBlockchainInfo);
  }

  Future<RPCMiddleWare> getDSBlock({int blockNum}) async {
    return await this.messenger.send(RPCMethod.GetDSBlock, blockNum.toString());
  }

  Future<RPCMiddleWare> getLatestDSBlock() async {
    return await this.messenger.send(RPCMethod.GetLatestDSBlock);
  }

  Future<RPCMiddleWare> getNumDSBlocks() async {
    return await this.messenger.send(RPCMethod.GetNumDSBlocks);
  }

  Future<RPCMiddleWare> getDSBlockRate() async {
    return await this.messenger.send(RPCMethod.GetDSBlockRate);
  }

  Future<RPCMiddleWare> getDSBlockListing({int max}) async {
    return await this.messenger.send(RPCMethod.DSBlockListing, max);
  }

  Future<RPCMiddleWare> getTxBlock({int blockNum}) async {
    return await this.messenger.send(RPCMethod.GetTxBlock, blockNum.toString());
  }

  Future<RPCMiddleWare> getLatestTxBlock() async {
    return await this.messenger.send(RPCMethod.GetLatestTxBlock);
  }

  Future<RPCMiddleWare> getNumTxBlocks() async {
    return await this.messenger.send(RPCMethod.GetNumTxBlocks);
  }

  Future<RPCMiddleWare> getTxBlockRate() async {
    return await this.messenger.send(RPCMethod.GetTxBlockRate);
  }

  Future<RPCMiddleWare> getTxBlockListing({int max}) async {
    return await this.messenger.send(RPCMethod.TxBlockListing, max);
  }

  Future<RPCMiddleWare> getNumTransactions() async {
    return await this.messenger.send(RPCMethod.GetNumTransactions);
  }

  Future<RPCMiddleWare> getTransactionRate() async {
    return await this.messenger.send(RPCMethod.GetTransactionRate);
  }

  Future<RPCMiddleWare> getCurrentMiniEpoch() async {
    return await this.messenger.send(RPCMethod.GetCurrentMiniEpoch);
  }

  Future<RPCMiddleWare> getCurrentDSEpoch() async {
    return await this.messenger.send(RPCMethod.GetCurrentDSEpoch);
  }

  Future<RPCMiddleWare> getPrevDifficulty() async {
    return await this.messenger.send(RPCMethod.GetPrevDifficulty);
  }

  Future<RPCMiddleWare> getPrevDSDifficulty() async {
    return await this.messenger.send(RPCMethod.GetPrevDSDifficulty);
  }

  Future<RPCMiddleWare> getRecentTransactions() async {
    return await this.messenger.send(RPCMethod.GetRecentTransactions);
  }

  Future<RPCMiddleWare> getNumTxnsTxEpoch({int epoch}) async {
    return await this.messenger.send(RPCMethod.GetNumTxnsTxEpoch, epoch);
  }

  Future<RPCMiddleWare> getNumTxnsDSEpoch({int epoch}) async {
    return await this.messenger.send(RPCMethod.GetNumTxnsDSEpoch, epoch);
  }

  Future<RPCMiddleWare> getMinimumGasPrice() async {
    return await this.messenger.send(RPCMethod.GetMinimumGasPrice);
  }

  Future<RPCMiddleWare> getTransactionsForTxBlock({int txBlock}) async {
    return await this
        .messenger
        .send(RPCMethod.GetTransactionsForTxBlock, txBlock);
  }

  // TODO: getTransaction
  // TODO: completeTransaction
  // TODO: createTransaction
  Future<TransactionSent> createTransaction(Transaction transaction) async {
    try {
      var res = await this
          .messenger
          .send(RPCMethod.CreateTransaction, transaction.toPayload);
      if (res.result != null) {
        var result = res.result.toMap();
        var TranID = result['TranID'];
        if (TranID == null) {
          throw 'Transaction fail';
        } else {
          transaction.TranID = TranID;
          transaction.status = TxStatus.Pending;
          return new TransactionSent(transaction, result);
        }
      } else if (res.error != null) {
        throw res.error.message;
      }
      return null;
    } catch (error) {
      throw error;
    }
  }

  // scilla-runner checker
  Future<RPCMiddleWare> checkCode({String code}) async {
    return await this
        .messenger
        .sendServer(Endpoint.ScillaCheck, {'code': code});
  }

  // scilla-runner call
  Future<RPCMiddleWare> testCall(Map callJson) async {
    return await this.messenger.sendServer(Endpoint.ScillaCall, {
      //don't encode code, provider will encode it automatically
      'code': callJson['code'].toString(),
      'init': json.encode(callJson['init']),
      'blockchain': json.encode(callJson['blockchain']),
      'gaslimit': json.encode(callJson['gasLimit'])
    });
  }
}
