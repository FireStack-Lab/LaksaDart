abstract class TxParams {
  int? version;
  String? TranID;
  String? toAddr;
  int? nonce = 0;
  String? pubKey;
  BigInt? amount;
  BigInt? gasPrice;
  int? gasLimit;
  String? code;
  String? data;
  Map<String, dynamic>? receipt;
  String? signature;
}

abstract class BaseTransaction extends TxParams {
  // Map get txParams;
  // Map get toPayload;
  // Uint8List get bytes;
  // String get senderAddress;
}

enum TxStatus {
  Initialised,
  Pending,
  Confirmed,
  Rejected,
}
