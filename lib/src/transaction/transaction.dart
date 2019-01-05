import 'dart:convert';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'api.dart';

class TransactionSent {
  Transaction transaction;
  Map result;
  TransactionSent(this.transaction, this.result);
}

class Transaction implements BaseTransaction {
  int version = 0;
  String TranID;
  String toAddr;
  int nonce = 0;
  String pubKey;
  BigInt amount;
  BigInt gasPrice;
  int gasLimit;
  String code;
  String data;
  Map<String, dynamic> receipt;
  String signature;

  // messenger
  Messenger messenger;

  // getter txParmas
  Map<String, dynamic> get txParams => {
        'version': this.version,
        'toAddr': this.toAddr,
        'nonce': this.nonce,
        'pubKey': this.pubKey,
        'amount': this.amount,
        'gasPrice': this.gasPrice,
        'gasLimit': this.gasLimit,
        'code': this.code,
        'data': this.data,
        'signature': this.signature,
        'receipt': this.receipt,
      };

  // getter toPayload
  Map<String, dynamic> get toPayload => {
        'version': this.version,
        'toAddr': this.toAddr,
        'nonce': this.nonce,
        'pubKey': this.pubKey,
        'amount': this.amount.toString(),
        'gasPrice': this.gasPrice.toString(),
        'gasLimit': this.gasLimit.toString(),
        'code': this.code,
        'data': this.data,
        'signature': this.signature
        // 'receipt': this.receipt,
      };
  // Uint8List get bytes;
  // String get senderAddress;
  TxStatus status;

  Transaction(
      {Map params,
      Messenger messenger,
      TxStatus status = TxStatus.Initialised}) {
    // params
    this.version = params['version'];
    this.TranID = params['TranID'];
    this.toAddr = params['toAddr'];
    this.nonce = params['nonce'];
    this.pubKey = params['pubKey'];
    this.amount = params['amount'];
    this.code = params['code'];
    this.data = params['data'];
    this.signature = params['signature'];
    this.gasPrice = params['gasPrice'];
    this.gasLimit = params['gasLimit'];
    this.receipt = params['receipt'];
    // // status
    this.status = status;
    this.messenger = messenger;
  }

  /**
   * isPending
   *
   * @returns {boolean}
   */
  bool isPending() {
    return this.status == TxStatus.Pending;
  }

  /**
   * isInitialised
   *
   * @returns {boolean}
   */
  bool isInitialised() {
    return this.status == TxStatus.Initialised;
  }

  /**
   * isConfirmed
   *
   * @returns {boolean}
   */
  bool isConfirmed() {
    return this.status == TxStatus.Confirmed;
  }

  /**
   * isRejected
   *
   * @returns {boolean}
   */
  bool isRejected() {
    return this.status == TxStatus.Rejected;
  }

  /**
   * confirm
   *
   * constructs an already-confirmed transaction.
   *
   * @static
   * @param {BaseTx} params
   */
  static confirm(Map params, Messenger messenger) {
    return new Transaction(
        params: params, messenger: messenger, status: TxStatus.Confirmed);
  }

  /**
   * reject
   *
   * constructs an already-rejected transaction.
   *
   * @static
   * @param {BaseTx} params
   */
  static reject(Map params, Messenger messenger) {
    return new Transaction(
        params: params, messenger: messenger, status: TxStatus.Rejected);
  }

  /**
   * setProvider
   *
   * Sets the provider on this instance.
   *
   * @param {Provider} provider
   */
  void setProvider(Messenger messenger) {
    this.messenger = messenger;
  }

  /**
   * setStatus
   *
   * Escape hatch to imperatively set the state of the transaction.
   *
   * @param {TxStatus} status
   * @returns {undefined}
   */
  Transaction setStatus(TxStatus status) {
    this.status = status;
    return this;
  }

  void setParams(Map params) {
    this.version = params['version'];
    this.TranID = params['TranID'];
    this.toAddr = params['toAddr'];
    this.nonce = params['nonce'];
    this.pubKey = params['pubKey'];
    this.amount = params['amount'];
    this.code = params['code'] != null ? params['code'] : '';
    this.data = params['data'] != null ? params['data'] : '';
    this.signature = params['signature'];
    this.gasPrice = params['gasPrice'];
    this.gasLimit = params['gasLimit'];
    this.receipt = params['receipt'];
  }

  /**
   * map
   *
   * maps over the transaction, allowing for manipulation.
   *
   * @param {(prev: TxParams) => TxParams} fn - mapper
   * @returns {Transaction}
   */
  Transaction map(Function mapFn) {
    Map newParams = mapFn(this.txParams);

    this.setParams(newParams);
    return this;
  }

  /**
   * If a transaction is sigend , can be sent and get TranID,
   * We set the This.TranID = TranID and return Transaction Object and response
   * @function {sendTxn}
   * @return {transaction:Promise<Transaction|Error>,response:Promise<Response>} {Transaction}
   */
  Future<TransactionSent> sendTransaction() async {
    try {
      if (this.signature == null) {
        throw 'The Transaction has not been signed';
      }
      var res = await this
          .messenger
          .send(RPCMethod.CreateTransaction, this.toPayload);
      if (res.result != null) {
        var result = res.result.toMap();
        var TranID = result['TranID'];
        if (TranID == null) {
          throw 'Transaction fail';
        } else {
          this.TranID = TranID;
          this.status = TxStatus.Pending;
          return new TransactionSent(this, result);
        }
      } else if (res.error != null) {
        throw res.error.message;
      } else
        return null;
    } catch (error) {
      throw error;
    }
  }
}
