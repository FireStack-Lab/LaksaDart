import 'dart:async';
import 'dart:convert';
import 'package:laksadart/laksadart.dart';
import 'package:laksadart/src/account/account.dart';
import 'package:laksadart/src/account/wallet.dart';
import 'package:laksadart/src/account/address.dart';
import 'package:laksadart/src/messenger/messenger.dart';
import 'package:laksadart/src/transaction/transaction.dart';
import 'util.dart';
import 'api.dart';

class Contract implements BaseContract {
  String code = '';
  List<Map>? init = [];
  String? contractAddress;
  ContractStatus? status;
  Transaction? transaction;
  int? version;
  bool? toDS = false;
  //----- factory ---//
  Messenger? messenger;
  Wallet? wallet;
  Account? get signer => this.wallet!.getAccount(this.wallet!.defaultAccount);

  Contract(
      {required Map params,
      Messenger? messenger,
      Wallet? wallet,
      ContractStatus? status = ContractStatus.INITIALISED,
      bool? toDS = false}) {
    this.code = params['code'] ?? '';
    this.init = params['init'] ?? [];
    this.version = params['version'] ?? 0;
    this.transaction = params['transaction'] ?? null;
    this.contractAddress = params['ContractAddress'] ?? '';
    this.status = params['status'] ?? status;
    // factory
    this.messenger = messenger;
    this.wallet = wallet;
    this.toDS = toDS;
  }

  bool isInitialised() {
    return this.status == ContractStatus.INITIALISED;
  }

  bool isSigned() {
    return this.status == ContractStatus.SIGNED;
  }

  bool isSent() {
    return this.status == ContractStatus.SENT;
  }

  bool isDeployed() {
    return this.status == ContractStatus.DEPLOYED;
  }

  bool isRejected() {
    return this.status == ContractStatus.REJECTED;
  }

  Map get deployPayload => {
        'version': this.version,
        'amount': BigInt.from(0),
        'toAddr': ZilAddress.toValidAddress('0x' + '0' * 40),
        'code': this.code,
        'data': json.encode(this.init).replaceAll(r"/\\", '"')
      };

  Map get callPayload => {
        'version': this.version,
        'toAddr': ZilAddress.toCheckSum(this.contractAddress!)
      };

  void setStatus(ContractStatus status) {
    this.status = status;
  }

  Future<Contract> deploy(
      {int? gasLimit,
      BigInt? gasPrice,
      Account? account,
      String? passphrase,
      int maxAttempts = 20,
      int interval = 1000,
      bool toDS = false}) async {
    var defaultGasLimit = 2500000000;
    var defaultGasPrice = BigInt.from(100000000);

    if (this.init == null) {
      throw 'Cannot deploy without code or ABI.';
    }

    try {
      this.setDeployPayload(
          gasLimit: gasLimit ?? defaultGasLimit,
          gasPrice: gasPrice ?? defaultGasPrice,
          toDS: toDS);
      await this.sendContract(
          account: account ?? this.signer, passphrase: passphrase);
      await this.confirmTx(maxAttempts: maxAttempts, interval: interval);
      return this;
    } catch (err) {
      rethrow;
    }
  }

  Future<Contract> call(
      {String? transition,
      params,
      BigInt? amount,
      int gasLimit = 1000,
      BigInt? gasPrice,
      Account? account,
      String? passphrase,
      int maxAttempts = 20,
      int interval = 1000,
      bool toDS = false}) async {
    if (this.contractAddress == null) {
      throw 'Contract has not been deployed!';
    }
    var defaultAmount = BigInt.from(10000);
    var defaultGasPrice = BigInt.from(100000000);
    try {
      this.setCallPayload(
          transition: transition,
          params: params,
          amount: amount ?? defaultAmount,
          gasLimit: gasLimit,
          gasPrice: gasPrice ?? defaultGasPrice,
          toDS: toDS);
      await this.sendContract(
          account: account ?? this.signer, passphrase: passphrase);
      await this.confirmTx(maxAttempts: maxAttempts, interval: interval);
      return this;
    } catch (err) {
      rethrow;
    }
  }

  Future<Contract> confirmTx(
      {int maxAttempts = 20, int interval = 1000}) async {
    try {
      await this.transaction!.confirm(
          txHash: this.transaction!.transactionID,
          maxAttempts: maxAttempts,
          interval: interval);
      if (this.transaction!.receipt == null ||
          !this.transaction!.receipt!['success']) {
        this.setStatus(ContractStatus.REJECTED);
        return this;
      }
      this.setStatus(ContractStatus.DEPLOYED);
      return this;
    } catch (error) {
      rethrow;
    }
  }

  Future<Contract> sendContract({Account? account, String? passphrase}) async {
    try {
      await this.signTxn(account: account, passphrase: passphrase);

      var txnSent = await this.transaction!.sendTransaction();

      var transaction = txnSent!.transaction;
      var result = txnSent.result;

      this.contractAddress = this.contractAddress!.isNotEmpty
          ? this.contractAddress
          : result['ContractAddress'];

      this.transaction = transaction.map((obj) {
        var resultMap = Map.from(obj);
        var newMap = {'TranID': result['TranID']};
        resultMap.addAll(newMap);
        return resultMap;
      });

      this.setStatus(ContractStatus.SENT);

      return this;
    } catch (error) {
      rethrow;
    }
  }

  Future<Contract> signTxn({Account? account, String? passphrase}) async {
    Account signingAccount = account ?? this.signer!;
    try {
      this.transaction = await signingAccount.signTransaction(this.transaction,
          passphrase: passphrase);
      this.setStatus(ContractStatus.SIGNED);

      return this;
    } catch (error) {
      rethrow;
    }
  }

  Future<SuccessMiddleware?> getState() async {
    if (this.status != ContractStatus.DEPLOYED) {
      return null;
    }
    var response = await this
        .messenger!
        .send(RPCMethod.GetSmartContractState, this.contractAddress);
    return response.result;
  }

  Contract setInitParamsValues(List<Map> initParams, List<Map> arrayOfValues) {
    List<Map> result = setParamValues(initParams, arrayOfValues);
    this.init = result;
    return this;
  }

  Contract setDeployPayload(
      {BigInt? gasPrice, int? gasLimit, bool toDS = false}) {
    Map add = {
      'gasPrice': gasPrice,
      'gasLimit': gasLimit,
    };
    Map params = Map.from(this.deployPayload);
    params.addAll(add);

    this.transaction =
        new Transaction(params: params, messenger: this.messenger, toDS: toDS);

    return this;
  }

  Contract setCallPayload(
      {String? transition,
      List<Map>? params,
      BigInt? amount,
      int? gasLimit,
      BigInt? gasPrice,
      bool toDS = false}) {
    Map msg = {
      '_tag': transition,
      'params': params,
    };
    Map txnParams = Map.from(this.callPayload);
    Map newMaps = {
      'amount': amount,
      'gasPrice': gasPrice,
      'gasLimit': gasLimit,
      'data': json.encode(msg)
    };
    txnParams.addAll(newMaps);
    this.transaction = new Transaction(
        params: txnParams, messenger: this.messenger, toDS: toDS);
    return this;
  }
}
