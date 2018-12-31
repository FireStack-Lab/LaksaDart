///
//  Generated code. Do not modify.
//  source: proto/message.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class ByteArray extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ByteArray', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<List<int>>(1, 'data', $pb.PbFieldType.QY)
  ;

  ByteArray() : super();
  ByteArray.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ByteArray.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ByteArray clone() => new ByteArray()..mergeFromMessage(this);
  ByteArray copyWith(void Function(ByteArray) updates) => super.copyWith((message) => updates(message as ByteArray));
  $pb.BuilderInfo get info_ => _i;
  static ByteArray create() => new ByteArray();
  static $pb.PbList<ByteArray> createRepeated() => new $pb.PbList<ByteArray>();
  static ByteArray getDefault() => _defaultInstance ??= create()..freeze();
  static ByteArray _defaultInstance;
  static void $checkItem(ByteArray v) {
    if (v is! ByteArray) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) { $_setBytes(0, v); }
  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class ProtoTransactionCoreInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ProtoTransactionCoreInfo', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<int>(1, 'version', $pb.PbFieldType.QU3)
    ..a<Int64>(2, 'nonce', $pb.PbFieldType.QU6, Int64.ZERO)
    ..a<List<int>>(3, 'toaddr', $pb.PbFieldType.QY)
    ..a<ByteArray>(4, 'senderpubkey', $pb.PbFieldType.QM, ByteArray.getDefault, ByteArray.create)
    ..a<ByteArray>(5, 'amount', $pb.PbFieldType.QM, ByteArray.getDefault, ByteArray.create)
    ..a<ByteArray>(6, 'gasprice', $pb.PbFieldType.QM, ByteArray.getDefault, ByteArray.create)
    ..a<Int64>(7, 'gaslimit', $pb.PbFieldType.QU6, Int64.ZERO)
    ..a<List<int>>(8, 'code', $pb.PbFieldType.QY)
    ..a<List<int>>(9, 'data', $pb.PbFieldType.QY)
  ;

  ProtoTransactionCoreInfo() : super();
  ProtoTransactionCoreInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ProtoTransactionCoreInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ProtoTransactionCoreInfo clone() => new ProtoTransactionCoreInfo()..mergeFromMessage(this);
  ProtoTransactionCoreInfo copyWith(void Function(ProtoTransactionCoreInfo) updates) => super.copyWith((message) => updates(message as ProtoTransactionCoreInfo));
  $pb.BuilderInfo get info_ => _i;
  static ProtoTransactionCoreInfo create() => new ProtoTransactionCoreInfo();
  static $pb.PbList<ProtoTransactionCoreInfo> createRepeated() => new $pb.PbList<ProtoTransactionCoreInfo>();
  static ProtoTransactionCoreInfo getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransactionCoreInfo _defaultInstance;
  static void $checkItem(ProtoTransactionCoreInfo v) {
    if (v is! ProtoTransactionCoreInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get version => $_get(0, 0);
  set version(int v) { $_setUnsignedInt32(0, v); }
  bool hasVersion() => $_has(0);
  void clearVersion() => clearField(1);

  Int64 get nonce => $_getI64(1);
  set nonce(Int64 v) { $_setInt64(1, v); }
  bool hasNonce() => $_has(1);
  void clearNonce() => clearField(2);

  List<int> get toaddr => $_getN(2);
  set toaddr(List<int> v) { $_setBytes(2, v); }
  bool hasToaddr() => $_has(2);
  void clearToaddr() => clearField(3);

  ByteArray get senderpubkey => $_getN(3);
  set senderpubkey(ByteArray v) { setField(4, v); }
  bool hasSenderpubkey() => $_has(3);
  void clearSenderpubkey() => clearField(4);

  ByteArray get amount => $_getN(4);
  set amount(ByteArray v) { setField(5, v); }
  bool hasAmount() => $_has(4);
  void clearAmount() => clearField(5);

  ByteArray get gasprice => $_getN(5);
  set gasprice(ByteArray v) { setField(6, v); }
  bool hasGasprice() => $_has(5);
  void clearGasprice() => clearField(6);

  Int64 get gaslimit => $_getI64(6);
  set gaslimit(Int64 v) { $_setInt64(6, v); }
  bool hasGaslimit() => $_has(6);
  void clearGaslimit() => clearField(7);

  List<int> get code => $_getN(7);
  set code(List<int> v) { $_setBytes(7, v); }
  bool hasCode() => $_has(7);
  void clearCode() => clearField(8);

  List<int> get data => $_getN(8);
  set data(List<int> v) { $_setBytes(8, v); }
  bool hasData() => $_has(8);
  void clearData() => clearField(9);
}

class ProtoTransaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ProtoTransaction', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<List<int>>(1, 'tranid', $pb.PbFieldType.QY)
    ..a<ProtoTransactionCoreInfo>(2, 'info', $pb.PbFieldType.QM, ProtoTransactionCoreInfo.getDefault, ProtoTransactionCoreInfo.create)
    ..a<ByteArray>(3, 'signature', $pb.PbFieldType.QM, ByteArray.getDefault, ByteArray.create)
  ;

  ProtoTransaction() : super();
  ProtoTransaction.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ProtoTransaction.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ProtoTransaction clone() => new ProtoTransaction()..mergeFromMessage(this);
  ProtoTransaction copyWith(void Function(ProtoTransaction) updates) => super.copyWith((message) => updates(message as ProtoTransaction));
  $pb.BuilderInfo get info_ => _i;
  static ProtoTransaction create() => new ProtoTransaction();
  static $pb.PbList<ProtoTransaction> createRepeated() => new $pb.PbList<ProtoTransaction>();
  static ProtoTransaction getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransaction _defaultInstance;
  static void $checkItem(ProtoTransaction v) {
    if (v is! ProtoTransaction) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get tranid => $_getN(0);
  set tranid(List<int> v) { $_setBytes(0, v); }
  bool hasTranid() => $_has(0);
  void clearTranid() => clearField(1);

  ProtoTransactionCoreInfo get info => $_getN(1);
  set info(ProtoTransactionCoreInfo v) { setField(2, v); }
  bool hasInfo() => $_has(1);
  void clearInfo() => clearField(2);

  ByteArray get signature => $_getN(2);
  set signature(ByteArray v) { setField(3, v); }
  bool hasSignature() => $_has(2);
  void clearSignature() => clearField(3);
}

class ProtoTransactionReceipt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ProtoTransactionReceipt', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<List<int>>(1, 'receipt', $pb.PbFieldType.QY)
    ..a<Int64>(2, 'cumgas', $pb.PbFieldType.QU6, Int64.ZERO)
  ;

  ProtoTransactionReceipt() : super();
  ProtoTransactionReceipt.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ProtoTransactionReceipt.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ProtoTransactionReceipt clone() => new ProtoTransactionReceipt()..mergeFromMessage(this);
  ProtoTransactionReceipt copyWith(void Function(ProtoTransactionReceipt) updates) => super.copyWith((message) => updates(message as ProtoTransactionReceipt));
  $pb.BuilderInfo get info_ => _i;
  static ProtoTransactionReceipt create() => new ProtoTransactionReceipt();
  static $pb.PbList<ProtoTransactionReceipt> createRepeated() => new $pb.PbList<ProtoTransactionReceipt>();
  static ProtoTransactionReceipt getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransactionReceipt _defaultInstance;
  static void $checkItem(ProtoTransactionReceipt v) {
    if (v is! ProtoTransactionReceipt) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get receipt => $_getN(0);
  set receipt(List<int> v) { $_setBytes(0, v); }
  bool hasReceipt() => $_has(0);
  void clearReceipt() => clearField(1);

  Int64 get cumgas => $_getI64(1);
  set cumgas(Int64 v) { $_setInt64(1, v); }
  bool hasCumgas() => $_has(1);
  void clearCumgas() => clearField(2);
}

class ProtoTransactionWithReceipt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ProtoTransactionWithReceipt', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<ProtoTransaction>(1, 'transaction', $pb.PbFieldType.QM, ProtoTransaction.getDefault, ProtoTransaction.create)
    ..a<ProtoTransactionReceipt>(2, 'receipt', $pb.PbFieldType.QM, ProtoTransactionReceipt.getDefault, ProtoTransactionReceipt.create)
  ;

  ProtoTransactionWithReceipt() : super();
  ProtoTransactionWithReceipt.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ProtoTransactionWithReceipt.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ProtoTransactionWithReceipt clone() => new ProtoTransactionWithReceipt()..mergeFromMessage(this);
  ProtoTransactionWithReceipt copyWith(void Function(ProtoTransactionWithReceipt) updates) => super.copyWith((message) => updates(message as ProtoTransactionWithReceipt));
  $pb.BuilderInfo get info_ => _i;
  static ProtoTransactionWithReceipt create() => new ProtoTransactionWithReceipt();
  static $pb.PbList<ProtoTransactionWithReceipt> createRepeated() => new $pb.PbList<ProtoTransactionWithReceipt>();
  static ProtoTransactionWithReceipt getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransactionWithReceipt _defaultInstance;
  static void $checkItem(ProtoTransactionWithReceipt v) {
    if (v is! ProtoTransactionWithReceipt) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  ProtoTransaction get transaction => $_getN(0);
  set transaction(ProtoTransaction v) { setField(1, v); }
  bool hasTransaction() => $_has(0);
  void clearTransaction() => clearField(1);

  ProtoTransactionReceipt get receipt => $_getN(1);
  set receipt(ProtoTransactionReceipt v) { setField(2, v); }
  bool hasReceipt() => $_has(1);
  void clearReceipt() => clearField(2);
}

