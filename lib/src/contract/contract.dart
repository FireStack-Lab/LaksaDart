import 'dart:typed_data';
import 'dart:convert';
import 'package:laksaDart/src/account/account.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/transaction/transaction.dart';
import 'util.dart';
import 'api.dart';

class Contract implements BaseContract {
  String code = '';
  List<Map> init = [];
  String ContractAddress;
  Messenger messenger;
  ContractStatus status;
  Transaction transaction;

  Contract(
      {Map params,
      Messenger messenger,
      ContractStatus status = ContractStatus.INITIALISED}) {
    this.code = params['code'] != null ? params['code'] : '';
    this.init = params['init'] != null ? params['init'] : [];
    this.ContractAddress =
        params['ContractAddress'] != null ? params['ContractAddress'] : '';
    this.status = status;
    this.messenger = messenger;
    this.transaction = null;
  }

  /**
   * isInitialised
   *
   * Returns true if the contract has not been deployed
   *
   * @returns {boolean}
   */
  bool isInitialised() {
    return this.status == ContractStatus.INITIALISED;
  }

  /**
   * isSigned
   *
   * Returns true if the contract is signed
   *
   * @returns {boolean}
   */
  bool isSigned() {
    return this.status == ContractStatus.SIGNED;
  }

  /**
   * isSent
   *
   * Returns true if the contract is sent
   *
   * @returns {boolean}
   */
  bool isSent() {
    return this.status == ContractStatus.SENT;
  }

  /**
   * isDeployed
   *
   * Returns true if the contract is deployed
   *
   * @returns {boolean}
   */
  bool isDeployed() {
    return this.status == ContractStatus.DEPLOYED;
  }

  /**
   * isRejected
   *
   * Returns true if an attempt to deploy the contract was made, but the
   * underlying transaction was unsuccessful.
   *
   * @returns {boolean}
   */
  bool isRejected() {
    return this.status == ContractStatus.REJECTED;
  }

  /**
   * @function {payload}
   * @return {object} {default deployment payload}
   */
  Map get deployDayload => {
        'version': 0,
        'amount': BigInt.from(0),
        'toAddr': Int8List(40).toString(),
        'code': this.code,
        'data': json.encode(this.init).replaceAll(r"/\\", '"')
      };

  /**
   * @function {callPayload}
   * @param  {Map} Map get callPayload            {description}
   * @return {type} {description}
   */
  Map get callPayload => {'version': 0, 'toAddr': this.ContractAddress};

  /**
   * @function {setStatus}
   * @param  {string} status {contract status during all life-time}
   * @return {type} {set this.status}
   */
  void setStatus(ContractStatus status) {
    this.status = status;
  }

  /**
   * @function {deploy}
   * @param  {Object<{gasLimit:Long,gasPrice:BN}>} transactionParams { gasLimit and gasPrice}
   * @param  {Object<{account:Account,password?:String}>} accountParams {account and password}
   * @return {Contract} {Contract with finalty}
   */

  Future<Contract> deploy(
      {int gasLimit,
      BigInt gasPrice,
      Account account,
      String passphrase,
      int maxAttempts = 20,
      int interval = 1000}) async {
    var defaultGasLimit = 2500000000;
    var defaultGasPrice = BigInt.from(100000000);

    if (this.code == null || this.init == null) {
      throw 'Cannot deploy without code or ABI.';
    }

    try {
      this.setDeployPayload(
          gasLimit: gasLimit != null ? gasLimit : defaultGasLimit,
          gasPrice: gasPrice != null ? gasPrice : defaultGasPrice);
      await this.sendContract(account: account, passphrase: passphrase);
      await this.confirmTx(maxAttempts: maxAttempts, interval: interval);
      return this;
    } catch (err) {
      throw err;
    }
  }

  /**
   * call
   *
   * @param {string} transition
   * @param {any} params
   * @returns {Promise<Transaction>}
   */

  Future<Contract> call(
      {String transition,
      params,
      BigInt amount,
      int gasLimit = 1000,
      BigInt gasPrice,
      Account account,
      String passphrase,
      int maxAttempts = 20,
      int interval = 1000}) async {
    if (this.ContractAddress == null) {
      throw 'Contract has not been deployed!';
    }
    var defaultAmount = BigInt.from(10000);
    var defulatGasPrice = BigInt.from(100000000);
    try {
      this.setCallPayload(
          transition: transition,
          params: params,
          amount: amount != null ? amount : defaultAmount,
          gasLimit: gasLimit,
          gasPrice: gasPrice != null ? gasPrice : defulatGasPrice);
      await this.sendContract(account: account, passphrase: passphrase);
      await this.confirmTx(maxAttempts: maxAttempts, interval: interval);
      return this;
    } catch (err) {
      throw err;
    }
  }

  /**
   * @function {confirmTx}
   * @return {Contract} {Contract confirm with finalty}
   */
  Future<Contract> confirmTx(
      {int maxAttempts = 20, int interval = 1000}) async {
    try {
      await this.transaction.confirm(
          txHash: this.transaction.TranID,
          maxAttempts: maxAttempts,
          interval: interval);
      if (this.transaction.receipt != null ||
          !this.transaction.receipt['success']) {
        this.setStatus(ContractStatus.REJECTED);
        return this;
      }
      this.setStatus(ContractStatus.DEPLOYED);
      return this;
    } catch (error) {
      throw error;
    }
  }

  /**
   * @function {sendContract}
   * @param  {Object<{account:Account,password?:String}>} accountParams {account and password}
   * @return {Contract} {Contract Sent}
   */
  Future<Contract> sendContract({Account account, String passphrase}) async {
    try {
      await this.signTxn(account: account, passphrase: passphrase);

      var txnSent = await this.transaction.sendTransaction();
      var transaction = txnSent.transaction;
      var result = txnSent.result;

      this.ContractAddress = result['ContractAddress'];

      this.transaction = transaction.map((obj) {
        var resultMap = Map.from(obj);
        var newMap = {'TranID': result['TranID']};
        resultMap.addAll(newMap);
        return resultMap;
      });

      this.setStatus(ContractStatus.SENT);
      return this;
    } catch (error) {
      throw error;
    }
  }

  /**
   * @function {signTxn}
   * @param  {Object<{account:Account,password?:String}>} accountParams {account and password}
   * @return {Contract} {Contract Signed}
   */
  Future<Contract> signTxn({Account account, String passphrase}) async {
    try {
      this.transaction = await account.signTransaction(this.transaction,
          passphrase: passphrase);
      this.setStatus(ContractStatus.SIGNED);
      return this;
    } catch (error) {
      throw error;
    }
  }

  /**
   * @function {getState}
   * @return {type} {description}
   */
  Future<List> getState() async {
    if (this.status == ContractStatus.DEPLOYED) {
      return [];
    }
    var response = await this
        .messenger
        .send('GetSmartContractState', this.ContractAddress);
    if (response.result != null) {
      return response.result.resultList;
    }
    if (response.error != null) {
      throw response.error;
    }
    return null;
  }

  /**
   * @function {setInitParamsValues}
   * @param  {Array<Object>} initParams    {init params get from ABI}
   * @param  {Array<Object>} arrayOfValues {init params set for ABI}
   * @return {Contract} {raw contract object}
   */
  Contract setInitParamsValues(List<Map> initParams, List<Map> arrayOfValues) {
    List<Map> result = setParamValues(initParams, arrayOfValues);
    this.init = result;
    return this;
  }

  Contract setDeployPayload({BigInt gasPrice, int gasLimit}) {
    Map add = {
      'gasPrice': gasPrice,
      'gasLimit': gasLimit,
    };
    Map params = Map.from(this.deployDayload);
    params.addAll(add);

    this.transaction =
        new Transaction(params: params, messenger: this.messenger);
    return this;
  }

  Contract setCallPayload(
      {String transition,
      List<Map> params,
      BigInt amount,
      int gasLimit,
      BigInt gasPrice}) {
    Map msg = {
      '_tag': transition,

      // TODO: this should be string, but is not yet supported by lookup.
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
    this.transaction =
        new Transaction(params: txnParams, messenger: this.messenger);
    return this;
  }
}
