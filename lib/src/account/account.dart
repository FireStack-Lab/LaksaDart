import 'dart:convert';
import 'package:laksaDart/src/crypto/schnorr.dart' as crypto;
import 'package:laksaDart/src/crypto/keystore/api.dart';
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import './abstracts.dart' show BaseAccount;
import './address.dart';

// Account instance with keystore encrypt/decrypt
class Account implements BaseAccount, KeyStore {
  // static privatekey checker
  static final RegExp isPrivateKey =
      new RegExp(r"^(0x)?[0-9a-f]{64}", caseSensitive: false);

  // account model
  String privateKey;
  String publicKey;
  ZilAddress address;

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
  Account([String prv]) {
    this.privateKey = prv;
    this.publicKey = this.getPublicKey(prv);
    this.address = this.getAddress(prv);
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
      'address': this.address.toString()
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
}
