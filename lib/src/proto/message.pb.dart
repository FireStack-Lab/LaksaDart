///
//  Generated code. Do not modify.
//  source: message.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class ByteArray extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ByteArray', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ZilliqaMessage'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.QY)
  ;

  ByteArray._() : super();
  factory ByteArray() => create();
  factory ByteArray.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ByteArray.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ByteArray clone() => ByteArray()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ByteArray copyWith(void Function(ByteArray) updates) => super.copyWith((message) => updates(message as ByteArray)) as ByteArray; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ByteArray create() => ByteArray._();
  ByteArray createEmptyInstance() => create();
  static $pb.PbList<ByteArray> createRepeated() => $pb.PbList<ByteArray>();
  @$core.pragma('dart2js:noInline')
  static ByteArray getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ByteArray>(create);
  static ByteArray? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class ProtoTransactionCoreInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProtoTransactionCoreInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ZilliqaMessage'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nonce', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'toaddr', $pb.PbFieldType.OY)
    ..aOM<ByteArray>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderpubkey', subBuilder: ByteArray.create)
    ..aOM<ByteArray>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', subBuilder: ByteArray.create)
    ..aOM<ByteArray>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gasprice', subBuilder: ByteArray.create)
    ..a<$fixnum.Int64>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gaslimit', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
  ;

  ProtoTransactionCoreInfo._() : super();
  factory ProtoTransactionCoreInfo() => create();
  factory ProtoTransactionCoreInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransactionCoreInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoTransactionCoreInfo clone() => ProtoTransactionCoreInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoTransactionCoreInfo copyWith(void Function(ProtoTransactionCoreInfo) updates) => super.copyWith((message) => updates(message as ProtoTransactionCoreInfo)) as ProtoTransactionCoreInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionCoreInfo create() => ProtoTransactionCoreInfo._();
  ProtoTransactionCoreInfo createEmptyInstance() => create();
  static $pb.PbList<ProtoTransactionCoreInfo> createRepeated() => $pb.PbList<ProtoTransactionCoreInfo>();
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionCoreInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoTransactionCoreInfo>(create);
  static ProtoTransactionCoreInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nonce => $_getI64(1);
  @$pb.TagNumber(2)
  set nonce($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get toaddr => $_getN(2);
  @$pb.TagNumber(3)
  set toaddr($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToaddr() => $_has(2);
  @$pb.TagNumber(3)
  void clearToaddr() => clearField(3);

  @$pb.TagNumber(4)
  ByteArray get senderpubkey => $_getN(3);
  @$pb.TagNumber(4)
  set senderpubkey(ByteArray v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSenderpubkey() => $_has(3);
  @$pb.TagNumber(4)
  void clearSenderpubkey() => clearField(4);
  @$pb.TagNumber(4)
  ByteArray ensureSenderpubkey() => $_ensure(3);

  @$pb.TagNumber(5)
  ByteArray get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount(ByteArray v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => clearField(5);
  @$pb.TagNumber(5)
  ByteArray ensureAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  ByteArray get gasprice => $_getN(5);
  @$pb.TagNumber(6)
  set gasprice(ByteArray v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasGasprice() => $_has(5);
  @$pb.TagNumber(6)
  void clearGasprice() => clearField(6);
  @$pb.TagNumber(6)
  ByteArray ensureGasprice() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get gaslimit => $_getI64(6);
  @$pb.TagNumber(7)
  set gaslimit($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGaslimit() => $_has(6);
  @$pb.TagNumber(7)
  void clearGaslimit() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get code => $_getN(7);
  @$pb.TagNumber(8)
  set code($core.List<$core.int> v) { $_setBytes(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearCode() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get data => $_getN(8);
  @$pb.TagNumber(9)
  set data($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasData() => $_has(8);
  @$pb.TagNumber(9)
  void clearData() => clearField(9);
}

class ProtoTransaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProtoTransaction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ZilliqaMessage'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tranid', $pb.PbFieldType.OY)
    ..aOM<ProtoTransactionCoreInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'info', subBuilder: ProtoTransactionCoreInfo.create)
    ..aOM<ByteArray>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', subBuilder: ByteArray.create)
  ;

  ProtoTransaction._() : super();
  factory ProtoTransaction() => create();
  factory ProtoTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoTransaction clone() => ProtoTransaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoTransaction copyWith(void Function(ProtoTransaction) updates) => super.copyWith((message) => updates(message as ProtoTransaction)) as ProtoTransaction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransaction create() => ProtoTransaction._();
  ProtoTransaction createEmptyInstance() => create();
  static $pb.PbList<ProtoTransaction> createRepeated() => $pb.PbList<ProtoTransaction>();
  @$core.pragma('dart2js:noInline')
  static ProtoTransaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoTransaction>(create);
  static ProtoTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get tranid => $_getN(0);
  @$pb.TagNumber(1)
  set tranid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTranid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTranid() => clearField(1);

  @$pb.TagNumber(2)
  ProtoTransactionCoreInfo get info => $_getN(1);
  @$pb.TagNumber(2)
  set info(ProtoTransactionCoreInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearInfo() => clearField(2);
  @$pb.TagNumber(2)
  ProtoTransactionCoreInfo ensureInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  ByteArray get signature => $_getN(2);
  @$pb.TagNumber(3)
  set signature(ByteArray v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignature() => clearField(3);
  @$pb.TagNumber(3)
  ByteArray ensureSignature() => $_ensure(2);
}

class ProtoTransactionReceipt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProtoTransactionReceipt', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ZilliqaMessage'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receipt', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cumgas', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  ProtoTransactionReceipt._() : super();
  factory ProtoTransactionReceipt() => create();
  factory ProtoTransactionReceipt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransactionReceipt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoTransactionReceipt clone() => ProtoTransactionReceipt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoTransactionReceipt copyWith(void Function(ProtoTransactionReceipt) updates) => super.copyWith((message) => updates(message as ProtoTransactionReceipt)) as ProtoTransactionReceipt; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionReceipt create() => ProtoTransactionReceipt._();
  ProtoTransactionReceipt createEmptyInstance() => create();
  static $pb.PbList<ProtoTransactionReceipt> createRepeated() => $pb.PbList<ProtoTransactionReceipt>();
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionReceipt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoTransactionReceipt>(create);
  static ProtoTransactionReceipt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cumgas => $_getI64(1);
  @$pb.TagNumber(2)
  set cumgas($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCumgas() => $_has(1);
  @$pb.TagNumber(2)
  void clearCumgas() => clearField(2);
}

class ProtoTransactionWithReceipt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProtoTransactionWithReceipt', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ZilliqaMessage'), createEmptyInstance: create)
    ..aOM<ProtoTransaction>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transaction', subBuilder: ProtoTransaction.create)
    ..aOM<ProtoTransactionReceipt>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receipt', subBuilder: ProtoTransactionReceipt.create)
  ;

  ProtoTransactionWithReceipt._() : super();
  factory ProtoTransactionWithReceipt() => create();
  factory ProtoTransactionWithReceipt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoTransactionWithReceipt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoTransactionWithReceipt clone() => ProtoTransactionWithReceipt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoTransactionWithReceipt copyWith(void Function(ProtoTransactionWithReceipt) updates) => super.copyWith((message) => updates(message as ProtoTransactionWithReceipt)) as ProtoTransactionWithReceipt; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionWithReceipt create() => ProtoTransactionWithReceipt._();
  ProtoTransactionWithReceipt createEmptyInstance() => create();
  static $pb.PbList<ProtoTransactionWithReceipt> createRepeated() => $pb.PbList<ProtoTransactionWithReceipt>();
  @$core.pragma('dart2js:noInline')
  static ProtoTransactionWithReceipt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoTransactionWithReceipt>(create);
  static ProtoTransactionWithReceipt? _defaultInstance;

  @$pb.TagNumber(1)
  ProtoTransaction get transaction => $_getN(0);
  @$pb.TagNumber(1)
  set transaction(ProtoTransaction v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTransaction() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransaction() => clearField(1);
  @$pb.TagNumber(1)
  ProtoTransaction ensureTransaction() => $_ensure(0);

  @$pb.TagNumber(2)
  ProtoTransactionReceipt get receipt => $_getN(1);
  @$pb.TagNumber(2)
  set receipt(ProtoTransactionReceipt v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceipt() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceipt() => clearField(2);
  @$pb.TagNumber(2)
  ProtoTransactionReceipt ensureReceipt() => $_ensure(1);
}

