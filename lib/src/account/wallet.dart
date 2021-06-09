import 'dart:async';
import 'package:laksadart/src/core/zilliqa_module.dart';
import 'package:laksadart/src/messenger/messenger.dart';
import 'package:laksadart/src/utils/numbers.dart' as numbers;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import './api.dart' show BaseWallet;
import './account.dart';

class Wallet implements BaseWallet<List<String>>, ZilliqaModule {
  List<String> get accounts => List.from(this.toMap.keys);
  int get length => accounts.length;
  String? defaultAccount;
  Messenger? _messenger;
  Map<String, Account?> toMap = new Map<String, Account?>();

  Wallet(this._messenger);

  @override
  void set messenger(Messenger? messenger) => this._messenger = messenger;

  @override
  Messenger get messenger => this._messenger!;

  // add to wallet
  Account? add(dynamic obj) {
    if (obj is Account) {
      obj.messenger = this.messenger;
      MapEntry<String, Account> entry =
          new MapEntry(obj.address.toString(), obj);
      this.toMap.addEntries([entry]);
      this.getDefaultAccount();
      return this.getAccount(obj.address.toString());
    } else if (obj is String) {
      Account acc = new Account(obj, this.messenger);
      String address = acc.address.toString();
      MapEntry<String, Account> entryNew = new MapEntry(address, acc);
      this.toMap.addEntries([entryNew]);
      this.getDefaultAccount();
      return this.getAccount(address.toString());
    } else if (obj is Map) {
      Account acc = Account.fromMap(obj as Map<String, dynamic>);
      acc.messenger = this.messenger;
      String address = acc.address.toString();
      MapEntry<String, Account> entryNew = new MapEntry(address, acc);
      this.toMap.addEntries([entryNew]);
      this.getDefaultAccount();
      return this.getAccount(address.toString());
    } else {
      return null;
    }
  }

  Account create() {
    var acc = new Account(null, this.messenger).create();
    this.add(acc);
    return acc;
  }

  Future<Account> asyncCreate() async {
    var acc = await new Account(null, this.messenger).asyncCreate();
    this.add(acc);
    return acc;
  }

  void remove(String addr) {
    this.toMap.remove(addr);
    if (this.defaultAccount == addr) {
      this.defaultAccount = null;
    }
    this.getDefaultAccount();
  }

  void update(String addr, Account? account) {
    this.toMap.update(addr, (find) => account);
    this.getDefaultAccount();
  }

  Account? getAccount(String? addr) {
    return this.toMap[addr!];
  }

  Future<Account?> encryptAccount(String addr, String passphrase,
      [Map<String, dynamic>? options]) async {
    var found = this.getAccount(addr);
    if (found == null) return null;
    if (found is Account || !found.isEncrypted) {
      await found.encryptAccount(passphrase, options);
      this.update(addr, found);
      return found;
    } else {
      return null;
    }
  }

  Future<Account?> decryptAccount(
    String addr,
    String passphrase,
  ) async {
    var found = this.getAccount(addr);
    if (found == null) return null;
    if (found is Account || found.isEncrypted) {
      await found.decryptAccount(passphrase);
      this.update(addr, found);
      return found;
    } else {
      return null;
    }
  }

  Account? getDefaultAccount() {
    if (this.length == 0) {
      return null;
    }
    if (this.length == 1) {
      this.setDefaultAccount(this.accounts.first);
      return this.getAccount(this.defaultAccount);
    }
    return this.getAccount(this.defaultAccount);
  }

  void setDefaultAccount(String addr) {
    if (this.getAccount(addr) != null) {
      this.defaultAccount = addr;
    }
  }

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  bool isValidMnemonic(String phrase) {
    var list = phrase.trim().split(" ");
    if (list.length < 12) {
      return false;
    }
    return bip39.validateMnemonic(phrase);
  }

  Account? importAccountFromMnemonic(String phrase, int index) {
    if (!this.isValidMnemonic(phrase)) {
      throw 'Invalid mnemonic phrase: ${phrase}';
    }
    final seed = bip39.mnemonicToSeed(phrase);
    final hdKey = bip32.BIP32.fromSeed(seed);
    final rootString = "m/44'/313'/0'/0/$index";
    final childKey = hdKey.derivePath(rootString);
    String prvKeys = numbers.bytesToHex(childKey.privateKey!);
    var account = Account(prvKeys);
    return this.add(account);
  }
}
