import 'dart:core';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:laksadart/src/proto/message.pb.dart' as zMessage;
import './numbers.dart' as numbers;
import './common.dart';

Uint8List encodeTransactionProto(Map<String, dynamic> tx) {
  var txnBuffer = zMessage.ProtoTransactionCoreInfo.create();
  txnBuffer.version = tx['version'];
  txnBuffer.nonce = tx['nonce'] is int ? Int64(tx['nonce']) : Int64(0);
  txnBuffer.toaddr = numbers.hexToBytes(tx['toAddr'].toLowerCase());
  txnBuffer.senderpubkey = zMessage.ByteArray.create();
  txnBuffer.senderpubkey.data =
      numbers.hexToBytes(tx['pubKey'] is String ? tx['pubKey'] : '00');

  txnBuffer.amount = zMessage.ByteArray.create();
  txnBuffer.amount.data = numbers.intToBytes(tx['amount'], length: 16);
  txnBuffer.gasprice = zMessage.ByteArray.create();
  txnBuffer.gasprice.data = numbers.intToBytes(tx['gasPrice'], length: 16);
  txnBuffer.gaslimit = tx['gasLimit'] is int ? Int64(tx['gasLimit']) : Int64(0);
  txnBuffer.code = toArray(tx['code'] is String ? tx['code'] : '');
  txnBuffer.data = toArray(tx['data'] is String ? tx['data'] : '');
  return txnBuffer.writeToBuffer();
}
