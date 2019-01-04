abstract class BaseAccount {
  String privateKey;
}

abstract class BaseWallet<E> {
  E get accounts;
  int get length;
  String defaultAccount;
}

abstract class Signer {}
