import 'dart:convert';
import 'package:laksaDart/src/crypto/schnorr.dart' as crypto;
import 'package:laksaDart/src/crypto/keystore/api.dart';
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/core/ZilliqaModule.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/provider/Middleware.dart';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/transaction/transaction.dart';
import './api.dart' show BaseAccount;
import './address.dart';

// Account instance with keystore encrypt/decrypt
class Account
    implements
        BaseAccount,
        KeyStore,
        ZilliqaModule<Messenger, void>,
        AccountState {
  // static privatekey checker
  static final RegExp isPrivateKey =
      new RegExp(r"^(0x)?[0-9a-f]{64}", caseSensitive: false);

  Messenger messenger;
  // account model
  String privateKey;
  String publicKey;
  ZilAddress address;
  String balance = '0';
  int nonce = 0;

  bool isFound;
  // transalte privateKey to Big Int
  BigInt get privateKeyBigInt => Account._privateKeyToBigInt(this.privateKey);

  // transate privatekey to Bytes
  List<int> get privateKeyBytes => Account._privateKeyToBytes(this.privateKey);

  // get account Map
  Map<String, dynamic> get accountMap => this.toMap();

  // get keystore Map
  Map<String, dynamic> get keyStoreMap => this.getKeyStore();

  // account encryption checker
  bool get isEncrypted => this.checkEncrypted();

  //constructor
  Account([String privateKey, Messenger messenger]) {
    this.privateKey = privateKey;
    this.publicKey = this.getPublicKey(privateKey);
    this.address = this.getAddress(privateKey);
    this.setMessenger(messenger);
  }

  static fromFile(String keyStore, String passphrase) async {
    String newPrvKey = await decrypt(json.decode(keyStore), passphrase);
    return new Account(newPrvKey);
  }

  Future<String> toFile(String passphrase,
      [Map<String, dynamic> options]) async {
    await this.encryptAccount(passphrase, options);

    return json.encode(this.keyStoreMap);
  }

  // create method, should call constructor first
  Account create() {
    try {
      String prv = crypto.generatePrivateKey();
      return new Account(prv);
    } catch (e) {
      throw e;
    }
  }

  void setMessenger(Messenger messenger) {
    this.messenger = messenger;
  }

  // import account from hex string
  Account import(dynamic prvHex) {
    if (prvHex is String)
      return Account._importFromString(prvHex);
    else if (prvHex is BigInt)
      return Account._importFromBigInt(prvHex);
    else
      return new Account();
  }

  // to map method
  Map<String, dynamic> toMap() {
    return {
      'privateKey': this.privateKey,
      'publicKey': this.publicKey,
      'address': this.address.checkSumAddress.toString()
    };
  }

  // to json method
  String toJson() {
    return json.encode(this.accountMap);
  }

  // account encryption
  Future encryptAccount(String passphrase,
      [Map<String, dynamic> options]) async {
    if (this.privateKey is String &&
        Account.isPrivateKey.hasMatch(this.privateKey)) {
      this.privateKey = await encrypt(this.privateKey, passphrase, options);
    } else
      return null;
  }

  // account decyption
  Future decryptAccount(String passphrase) async {
    if (this.privateKey is String &&
        Account.isPrivateKey.hasMatch(this.privateKey)) {
      return null;
    }
    this.privateKey = await decrypt(json.decode(this.privateKey), passphrase);

    // return this;
  }

  Future<void> updateBalance() async {
    RPCResponseBody<SuccessMiddleware, ErrorMiddleware> res = await this
        .messenger
        .send(RPCMethod.GetBalance, this.address.toString());
    if (res.error == null && res.result != null) {
      var balanceMap = res.result.toMap();
      if (balanceMap != null) {
        this.balance = balanceMap['balance'];
        this.nonce = balanceMap['nonce'];
        this.isFound = true;
      }
    } else {
      this.balance = '0';
      this.nonce = 0;
      this.isFound = false;
    }
  }

  // keystore getter
  Map<String, dynamic> getKeyStore() {
    if (this.privateKey is String &&
        Account.isPrivateKey.hasMatch(this.privateKey)) {
      return null;
    }
    return json.decode(this.privateKey);
  }

  // private key to big int
  static BigInt _privateKeyToBigInt(String prv) {
    try {
      if (prv is String && Account.isPrivateKey.hasMatch(prv))
        return numbers.hexToInt(prv);
      else
        return null;
    } catch (e) {
      throw e;
    }
  }

  // privat key to bytes
  static List<int> _privateKeyToBytes(String prv) {
    try {
      if (prv is String && Account.isPrivateKey.hasMatch(prv))
        return numbers.hexToBytes(prv);
      else
        return null;
    } catch (e) {
      throw e;
    }
  }

  // import account from hex
  static Account _importFromString(String prvHex) {
    try {
      if (Account.isPrivateKey.hasMatch(prvHex)) {
        return new Account(prvHex);
      } else
        throw ArgumentError('PrivateKey is not correct');
    } catch (e) {
      throw e;
    }
  }

  // import account from BigInt
  static Account _importFromBigInt(BigInt number) {
    try {
      String prvHex = number.toRadixString(16);
      return Account._importFromString(prvHex);
    } catch (e) {
      throw e;
    }
  }

  // get publicKey from privatKey
  String getPublicKey(String privateKey) {
    if (privateKey != null && Account.isPrivateKey.hasMatch(privateKey))
      return crypto.getPubKeyFromPrivateKey(privateKey);
    else
      return null;
  }

  // get address key from privateKey
  ZilAddress getAddress(String privateKey) {
    if (privateKey != null && Account.isPrivateKey.hasMatch(privateKey))
      return ZilAddress.fromPrivateKey(privateKey);
    else
      return null;
  }

  // encryption checker
  bool checkEncrypted() {
    if (this.privateKey == null) {
      throw 'Account is corrupted';
    }
    Map store = this.getKeyStore();
    if (store is Map && store['crypto'] != null) {
      return true;
    } else
      return false;
  }

  /**
   * @function {signTransactionWithPassword} {sign plain object with password}
   * @param  {Transaction} txnObj {transaction object}
   * @param  {string} password          {password string}
   * @return {object} {signed transaction object}
   */
  Future<Transaction> signTransaction(Transaction txnObj,
      {String passphrase}) async {
    if (this.isEncrypted) {
      await this.decryptAccount(passphrase);
      await this.updateBalance();
      txnObj.txParams.update('nonce', (found) => this.nonce + 1,
          ifAbsent: () => this.nonce + 1);
      var signed = crypto.SchnorrSign(this.privateKey, txnObj.txParams);

      await this.encryptAccount(passphrase);
      return txnObj.map((Map obj) {
        return obj.addAll(signed);
      });
    } else {
      await this.updateBalance();
      Map<String, dynamic> newTxMap = Map.from(txnObj.txParams);
      newTxMap.update('nonce', (found) => this.nonce + 1,
          ifAbsent: () => this.nonce + 1);
      var signed = crypto.SchnorrSign(this.privateKey, newTxMap);

      return txnObj.map((Map obj) {
        obj.addAll(signed);
        return obj;
      });
    }
  }
}
