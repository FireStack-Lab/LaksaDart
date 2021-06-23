import 'package:laksadart/laksadart.dart';

abstract class ZilliqaModule {
  Messenger get messenger;
  void set messenger(Messenger messenger);
}

abstract class AccountState {
  bool get isEncrypted;
  bool? isFound;
  static void setEncrypt() {}
  static void setFound() {}
}
