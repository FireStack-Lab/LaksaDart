///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class ByteArray extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ByteArray', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<$core.List<$core.int>>(1, 'data', $pb.PbFieldType.QY)
  ;

  ByteArray._() : super();
  factory ByteArray() => create();
  factory ByteArray.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ByteArray.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ByteArray clone() => ByteArray()..mergeFromMessage(this);
  ByteArray copyWith(void Function(ByteArray) updates) => super.copyWith((message) => updates(message as ByteArray));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ByteArray create() => ByteArray._();
  ByteArray createEmptyInstance() => create();
  static $pb.PbList<ByteArray> createRepeated() => $pb.PbList<ByteArray>();
  static ByteArray getDefault() => _defaultInstance ??= create()..freeze();
  static ByteArray _defaultInstance;

  $core.List<$core.int> get data => $_getN(0);
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  $core.bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class ProtoTransactionCoreInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ProtoTransactionCoreInfo', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<$core.int>(1, 'version', $pb.PbFieldType.OU3)
    ..a<Int64>(2, 'nonce', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.List<$core.int>>(3, 'toaddr', $pb.PbFieldType.OY)
    ..a<ByteArray>(4, 'senderpubkey', $pb.PbFieldType.OM, ByteArray.getDefault, ByteArray.create)
    ..a<ByteArray>(5, 'amount', $pb.PbFieldType.OM, ByteArray.getDefault, ByteArray.create)
    ..a<ByteArray>(6, 'gasprice', $pb.PbFieldType.OM, ByteArray.getDefault, ByteArray.create)
    ..a<Int64>(7, 'gaslimit', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<$core.List<$core.int>>(8, 'code', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(9, 'data', $pb.PbFieldType.OY)
  ;

  ProtoTransactionCoreInfo._() : super();
  factory ProtoTransactionCoreInfo() => create();
  factory ProtoTransactionCoreInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransactionCoreInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ProtoTransactionCoreInfo clone() => ProtoTransactionCoreInfo()..mergeFromMessage(this);
  ProtoTransactionCoreInfo copyWith(void Function(ProtoTransactionCoreInfo) updates) => super.copyWith((message) => updates(message as ProtoTransactionCoreInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionCoreInfo create() => ProtoTransactionCoreInfo._();
  ProtoTransactionCoreInfo createEmptyInstance() => create();
  static $pb.PbList<ProtoTransactionCoreInfo> createRepeated() => $pb.PbList<ProtoTransactionCoreInfo>();
  static ProtoTransactionCoreInfo getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransactionCoreInfo _defaultInstance;

  $core.int get version => $_get(0, 0);
  set version($core.int v) { $_setUnsignedInt32(0, v); }
  $core.bool hasVersion() => $_has(0);
  void clearVersion() => clearField(1);

  Int64 get nonce => $_getI64(1);
  set nonce(Int64 v) { $_setInt64(1, v); }
  $core.bool hasNonce() => $_has(1);
  void clearNonce() => clearField(2);

  $core.List<$core.int> get toaddr => $_getN(2);
  set toaddr($core.List<$core.int> v) { $_setBytes(2, v); }
  $core.bool hasToaddr() => $_has(2);
  void clearToaddr() => clearField(3);

  ByteArray get senderpubkey => $_getN(3);
  set senderpubkey(ByteArray v) { setField(4, v); }
  $core.bool hasSenderpubkey() => $_has(3);
  void clearSenderpubkey() => clearField(4);

  ByteArray get amount => $_getN(4);
  set amount(ByteArray v) { setField(5, v); }
  $core.bool hasAmount() => $_has(4);
  void clearAmount() => clearField(5);

  ByteArray get gasprice => $_getN(5);
  set gasprice(ByteArray v) { setField(6, v); }
  $core.bool hasGasprice() => $_has(5);
  void clearGasprice() => clearField(6);

  Int64 get gaslimit => $_getI64(6);
  set gaslimit(Int64 v) { $_setInt64(6, v); }
  $core.bool hasGaslimit() => $_has(6);
  void clearGaslimit() => clearField(7);

  $core.List<$core.int> get code => $_getN(7);
  set code($core.List<$core.int> v) { $_setBytes(7, v); }
  $core.bool hasCode() => $_has(7);
  void clearCode() => clearField(8);

  $core.List<$core.int> get data => $_getN(8);
  set data($core.List<$core.int> v) { $_setBytes(8, v); }
  $core.bool hasData() => $_has(8);
  void clearData() => clearField(9);
}

class ProtoTransaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ProtoTransaction', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<$core.List<$core.int>>(1, 'tranid', $pb.PbFieldType.OY)
    ..a<ProtoTransactionCoreInfo>(2, 'info', $pb.PbFieldType.OM, ProtoTransactionCoreInfo.getDefault, ProtoTransactionCoreInfo.create)
    ..a<ByteArray>(3, 'signature', $pb.PbFieldType.OM, ByteArray.getDefault, ByteArray.create)
  ;

  ProtoTransaction._() : super();
  factory ProtoTransaction() => create();
  factory ProtoTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ProtoTransaction clone() => ProtoTransaction()..mergeFromMessage(this);
  ProtoTransaction copyWith(void Function(ProtoTransaction) updates) => super.copyWith((message) => updates(message as ProtoTransaction));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransaction create() => ProtoTransaction._();
  ProtoTransaction createEmptyInstance() => create();
  static $pb.PbList<ProtoTransaction> createRepeated() => $pb.PbList<ProtoTransaction>();
  static ProtoTransaction getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransaction _defaultInstance;

  $core.List<$core.int> get tranid => $_getN(0);
  set tranid($core.List<$core.int> v) { $_setBytes(0, v); }
  $core.bool hasTranid() => $_has(0);
  void clearTranid() => clearField(1);

  ProtoTransactionCoreInfo get info => $_getN(1);
  set info(ProtoTransactionCoreInfo v) { setField(2, v); }
  $core.bool hasInfo() => $_has(1);
  void clearInfo() => clearField(2);

  ByteArray get signature => $_getN(2);
  set signature(ByteArray v) { setField(3, v); }
  $core.bool hasSignature() => $_has(2);
  void clearSignature() => clearField(3);
}

class ProtoTransactionReceipt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ProtoTransactionReceipt', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<$core.List<$core.int>>(1, 'receipt', $pb.PbFieldType.OY)
    ..a<Int64>(2, 'cumgas', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  ProtoTransactionReceipt._() : super();
  factory ProtoTransactionReceipt() => create();
  factory ProtoTransactionReceipt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransactionReceipt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ProtoTransactionReceipt clone() => ProtoTransactionReceipt()..mergeFromMessage(this);
  ProtoTransactionReceipt copyWith(void Function(ProtoTransactionReceipt) updates) => super.copyWith((message) => updates(message as ProtoTransactionReceipt));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionReceipt create() => ProtoTransactionReceipt._();
  ProtoTransactionReceipt createEmptyInstance() => create();
  static $pb.PbList<ProtoTransactionReceipt> createRepeated() => $pb.PbList<ProtoTransactionReceipt>();
  static ProtoTransactionReceipt getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransactionReceipt _defaultInstance;

  $core.List<$core.int> get receipt => $_getN(0);
  set receipt($core.List<$core.int> v) { $_setBytes(0, v); }
  $core.bool hasReceipt() => $_has(0);
  void clearReceipt() => clearField(1);

  Int64 get cumgas => $_getI64(1);
  set cumgas(Int64 v) { $_setInt64(1, v); }
  $core.bool hasCumgas() => $_has(1);
  void clearCumgas() => clearField(2);
}

class ProtoTransactionWithReceipt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ProtoTransactionWithReceipt', package: const $pb.PackageName('ZilliqaMessage'))
    ..a<ProtoTransaction>(1, 'transaction', $pb.PbFieldType.OM, ProtoTransaction.getDefault, ProtoTransaction.create)
    ..a<ProtoTransactionReceipt>(2, 'receipt', $pb.PbFieldType.OM, ProtoTransactionReceipt.getDefault, ProtoTransactionReceipt.create)
  ;

  ProtoTransactionWithReceipt._() : super();
  factory ProtoTransactionWithReceipt() => create();
  factory ProtoTransactionWithReceipt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransactionWithReceipt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ProtoTransactionWithReceipt clone() => ProtoTransactionWithReceipt()..mergeFromMessage(this);
  ProtoTransactionWithReceipt copyWith(void Function(ProtoTransactionWithReceipt) updates) => super.copyWith((message) => updates(message as ProtoTransactionWithReceipt));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionWithReceipt create() => ProtoTransactionWithReceipt._();
  ProtoTransactionWithReceipt createEmptyInstance() => create();
  static $pb.PbList<ProtoTransactionWithReceipt> createRepeated() => $pb.PbList<ProtoTransactionWithReceipt>();
  static ProtoTransactionWithReceipt getDefault() => _defaultInstance ??= create()..freeze();
  static ProtoTransactionWithReceipt _defaultInstance;

  ProtoTransaction get transaction => $_getN(0);
  set transaction(ProtoTransaction v) { setField(1, v); }
  $core.bool hasTransaction() => $_has(0);
  void clearTransaction() => clearField(1);

  ProtoTransactionReceipt get receipt => $_getN(1);
  set receipt(ProtoTransactionReceipt v) { setField(2, v); }
  $core.bool hasReceipt() => $_has(1);
  void clearReceipt() => clearField(2);
}

