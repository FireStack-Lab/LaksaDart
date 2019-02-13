import 'package:laksadart/src/provider/net.dart';
import 'package:laksadart/src/messenger/Messenger.dart';
import 'package:laksadart/src/account/address.dart';
import 'package:laksadart/src/crypto/index.dart';
import 'util.dart';
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
  String get senderAddress => this._senderAddress();
  // messenger
  Messenger messenger;
  bool toDS = false;

  // getter txParmas
  Map<String, dynamic> get txParams => {
        'version': this.version,
        'toAddr': new ZilAddress(this.toAddr).checkSumAddress.substring(2),
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
        'version': this.version, //this.getVersion(),
        'toAddr': this.toAddr,
        'nonce': this.nonce,
        'pubKey': this.pubKey,
        'amount': this.amount.toString(),
        'gasPrice': this.gasPrice.toString(),
        'gasLimit': this.gasLimit.toString(),
        'code': this.code,
        'data': this.data,
        'signature': this.signature,
        'priority': this.toDS
        // 'receipt': this.receipt,
      };
  // Uint8List get bytes;
  // String get senderAddress;
  TxStatus status;

  String _senderAddress() {
    if (this.pubKey != null) {
      return '0' * 40;
    }
    return getAddressFromPublicKey(this.pubKey);
  }

  Transaction(
      {Map params,
      Messenger messenger,
      TxStatus status = TxStatus.Initialised,
      bool toDS = false}) {
    // params
    this.version = params['version'];
    this.TranID = params['TranID'];
    this.toAddr = params['toAddr'];
    this.nonce = params['nonce'];
    this.pubKey = params['pubKey'];
    this.amount = params['amount'];
    this.code = params['code'] ?? '';
    this.data = params['data'] ?? '';
    this.signature = params['signature'];
    this.gasPrice = params['gasPrice'];
    this.gasLimit = params['gasLimit'];
    this.receipt = params['receipt'];
    // // status
    this.status = status;
    this.messenger = messenger;
    this.toDS = toDS;
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
  static confirmTxn(Map params, Messenger messenger) {
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
    this.code = params['code'];
    this.data = params['data'];
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
      rethrow;
    }
  }

  Future<bool> trackTx(String txHash) async {
    // TODO: regex validation for txHash so we don't get garbage
    var res = await this.messenger.send(RPCMethod.GetTransaction, txHash);

    if (res.error != null) {
      return false;
    }

    this.TranID = res.result.resultMap['ID'];
    this.receipt = res.result.resultMap['receipt'];
    this.status = this.receipt != null && this.receipt['success']
        ? TxStatus.Confirmed
        : TxStatus.Rejected;

    return true;
  }

  /**
   * confirmReceipt
   *
   * Similar to the Promise API. This sets the Transaction instance to a state
   * of pending. Calling this function kicks off a passive loop that polls the
   * lookup node for confirmation on the txHash.
   *
   * The polls are performed with a linear backoff:
   *
   * `const delay = interval * attempt`
   *
   * This is a low-level method that you should generally not have to use
   * directly.
   *
   * @param {string} txHash
   * @param {number} maxAttempts
   * @param {number} initial interval in milliseconds
   * @returns {Promise<Transaction>}
   */
  Future<Transaction> confirm(
      {String txHash, int maxAttempts = 20, int interval = 1000}) async {
    this.status = TxStatus.Pending;
    int attempt = 0;
    do {
      try {
        if (await this.trackTx(txHash)) {
          return this;
        }
      } catch (err) {
        this.status = TxStatus.Rejected;
        rethrow;
      }
      if (attempt < maxAttempts - 1) {
        sleep(ms: interval * attempt, callback: () => attempt += 1);
      } else
        break;
    } while (attempt < maxAttempts);

    this.status = TxStatus.Rejected;
    throw 'The transaction is still not confirmed after ${maxAttempts} attemps.';
  }

  int getVersion() {
    var CHAIN_ID_BIT = 2 << 16;
    var b = this.version;
    return CHAIN_ID_BIT + b;
  }
}
