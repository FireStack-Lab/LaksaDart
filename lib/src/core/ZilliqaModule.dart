abstract class ZilliqaModule<M, F> {
  M messenger;
  F setMessenger(M data);
}

abstract class AccountState {
  bool get isEncrypted;
  bool isFound;
  static void setEncrypt() {}
  static void setFound() {}
}
