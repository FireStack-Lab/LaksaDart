import './abstracts.dart' show BaseWallet;
import './account.dart';

class Wallet implements BaseWallet<List<String>> {
  List<String> get accounts => List.from(this.toMap.keys);
  int get length => accounts.length;
  String defaultAccount;

  Map<String, Account> toMap = new Map<String, Account>();

  // factory
  Wallet();

  // add to wallet
  void add(dynamic obj) {
    if (obj is Account) {
      MapEntry<String, Account> entry =
          new MapEntry(obj.address.toString(), obj);
      this.toMap.addEntries([entry]);
      this.getDefaultAccount();
    } else if (obj is String) {
      Account acc = new Account(obj);
      String address = acc.address.toString();
      MapEntry<String, Account> entryNew = new MapEntry(address, acc);
      this.toMap.addEntries([entryNew]);
      this.getDefaultAccount();
    }
  }

  void create() {
    var acc = new Account().create();
    this.add(acc);
  }

  void remove(String addr) {
    this.toMap.remove(addr);
    if (this.defaultAccount == addr) this.defaultAccount = null;
    this.getDefaultAccount();
  }

  void update(String addr, Account account) {
    this.toMap.update(addr, (find) => account);
    this.getDefaultAccount();
  }

  Account getAccount(String addr) {
    return this.toMap[addr];
  }

  Future<Account> encryptAccount(String addr, String passphrase,
      [Map<String, dynamic> options]) async {
    var found = this.getAccount(addr);
    if (found is Account || !found.isEncrypted) {
      await found.encryptAccount(passphrase, options);
      this.update(addr, found);
      return found;
    } else
      return null;
  }

  Future<Account> decryptAccount(
    String addr,
    String passphrase,
  ) async {
    var found = this.getAccount(addr);
    if (found is Account || found.isEncrypted) {
      await found.decryptAccount(passphrase);
      this.update(addr, found);
      return found;
    } else
      return null;
  }

  Account getDefaultAccount() {
    if (this.length == 0) return null;
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
}
