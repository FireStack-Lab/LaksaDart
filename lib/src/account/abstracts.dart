abstract class BaseAccount {
  String privateKey;
}

abstract class BaseWallet<E> {
  //todo
  // Messenger messenger;
  // Account signer;
  E get accounts;
  int get length;
}

abstract class Signer {
  // todo
  // updateBalance
  // sign
}
