// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'network_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NetworkInfo _$NetworkInfoFromJson(Map<String, dynamic> json) {
  return _NetworkInfo.fromJson(json);
}

/// @nodoc
class _$NetworkInfoTearOff {
  const _$NetworkInfoTearOff();

  _NetworkInfo call(
      {int? chainID,
      String? networkID,
      String? nodeProviderUrl,
      String? blockExplorerUrl,
      String? blockExplorerNetwork}) {
    return _NetworkInfo(
      chainID: chainID,
      networkID: networkID,
      nodeProviderUrl: nodeProviderUrl,
      blockExplorerUrl: blockExplorerUrl,
      blockExplorerNetwork: blockExplorerNetwork,
    );
  }

  NetworkInfo fromJson(Map<String, Object> json) {
    return NetworkInfo.fromJson(json);
  }
}

/// @nodoc
const $NetworkInfo = _$NetworkInfoTearOff();

/// @nodoc
mixin _$NetworkInfo {
  int? get chainID => throw _privateConstructorUsedError;
  String? get networkID => throw _privateConstructorUsedError;
  String? get nodeProviderUrl => throw _privateConstructorUsedError;
  String? get blockExplorerUrl => throw _privateConstructorUsedError;
  String? get blockExplorerNetwork => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkInfoCopyWith<NetworkInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkInfoCopyWith<$Res> {
  factory $NetworkInfoCopyWith(
          NetworkInfo value, $Res Function(NetworkInfo) then) =
      _$NetworkInfoCopyWithImpl<$Res>;
  $Res call(
      {int? chainID,
      String? networkID,
      String? nodeProviderUrl,
      String? blockExplorerUrl,
      String? blockExplorerNetwork});
}

/// @nodoc
class _$NetworkInfoCopyWithImpl<$Res> implements $NetworkInfoCopyWith<$Res> {
  _$NetworkInfoCopyWithImpl(this._value, this._then);

  final NetworkInfo _value;
  // ignore: unused_field
  final $Res Function(NetworkInfo) _then;

  @override
  $Res call({
    Object? chainID = freezed,
    Object? networkID = freezed,
    Object? nodeProviderUrl = freezed,
    Object? blockExplorerUrl = freezed,
    Object? blockExplorerNetwork = freezed,
  }) {
    return _then(_value.copyWith(
      chainID: chainID == freezed
          ? _value.chainID
          : chainID // ignore: cast_nullable_to_non_nullable
              as int?,
      networkID: networkID == freezed
          ? _value.networkID
          : networkID // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeProviderUrl: nodeProviderUrl == freezed
          ? _value.nodeProviderUrl
          : nodeProviderUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      blockExplorerUrl: blockExplorerUrl == freezed
          ? _value.blockExplorerUrl
          : blockExplorerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      blockExplorerNetwork: blockExplorerNetwork == freezed
          ? _value.blockExplorerNetwork
          : blockExplorerNetwork // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$NetworkInfoCopyWith<$Res>
    implements $NetworkInfoCopyWith<$Res> {
  factory _$NetworkInfoCopyWith(
          _NetworkInfo value, $Res Function(_NetworkInfo) then) =
      __$NetworkInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? chainID,
      String? networkID,
      String? nodeProviderUrl,
      String? blockExplorerUrl,
      String? blockExplorerNetwork});
}

/// @nodoc
class __$NetworkInfoCopyWithImpl<$Res> extends _$NetworkInfoCopyWithImpl<$Res>
    implements _$NetworkInfoCopyWith<$Res> {
  __$NetworkInfoCopyWithImpl(
      _NetworkInfo _value, $Res Function(_NetworkInfo) _then)
      : super(_value, (v) => _then(v as _NetworkInfo));

  @override
  _NetworkInfo get _value => super._value as _NetworkInfo;

  @override
  $Res call({
    Object? chainID = freezed,
    Object? networkID = freezed,
    Object? nodeProviderUrl = freezed,
    Object? blockExplorerUrl = freezed,
    Object? blockExplorerNetwork = freezed,
  }) {
    return _then(_NetworkInfo(
      chainID: chainID == freezed
          ? _value.chainID
          : chainID // ignore: cast_nullable_to_non_nullable
              as int?,
      networkID: networkID == freezed
          ? _value.networkID
          : networkID // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeProviderUrl: nodeProviderUrl == freezed
          ? _value.nodeProviderUrl
          : nodeProviderUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      blockExplorerUrl: blockExplorerUrl == freezed
          ? _value.blockExplorerUrl
          : blockExplorerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      blockExplorerNetwork: blockExplorerNetwork == freezed
          ? _value.blockExplorerNetwork
          : blockExplorerNetwork // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NetworkInfo extends _NetworkInfo {
  const _$_NetworkInfo(
      {this.chainID,
      this.networkID,
      this.nodeProviderUrl,
      this.blockExplorerUrl,
      this.blockExplorerNetwork})
      : super._();

  factory _$_NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_NetworkInfoFromJson(json);

  @override
  final int? chainID;
  @override
  final String? networkID;
  @override
  final String? nodeProviderUrl;
  @override
  final String? blockExplorerUrl;
  @override
  final String? blockExplorerNetwork;

  @override
  String toString() {
    return 'NetworkInfo(chainID: $chainID, networkID: $networkID, nodeProviderUrl: $nodeProviderUrl, blockExplorerUrl: $blockExplorerUrl, blockExplorerNetwork: $blockExplorerNetwork)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NetworkInfo &&
            (identical(other.chainID, chainID) ||
                const DeepCollectionEquality()
                    .equals(other.chainID, chainID)) &&
            (identical(other.networkID, networkID) ||
                const DeepCollectionEquality()
                    .equals(other.networkID, networkID)) &&
            (identical(other.nodeProviderUrl, nodeProviderUrl) ||
                const DeepCollectionEquality()
                    .equals(other.nodeProviderUrl, nodeProviderUrl)) &&
            (identical(other.blockExplorerUrl, blockExplorerUrl) ||
                const DeepCollectionEquality()
                    .equals(other.blockExplorerUrl, blockExplorerUrl)) &&
            (identical(other.blockExplorerNetwork, blockExplorerNetwork) ||
                const DeepCollectionEquality()
                    .equals(other.blockExplorerNetwork, blockExplorerNetwork)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(chainID) ^
      const DeepCollectionEquality().hash(networkID) ^
      const DeepCollectionEquality().hash(nodeProviderUrl) ^
      const DeepCollectionEquality().hash(blockExplorerUrl) ^
      const DeepCollectionEquality().hash(blockExplorerNetwork);

  @JsonKey(ignore: true)
  @override
  _$NetworkInfoCopyWith<_NetworkInfo> get copyWith =>
      __$NetworkInfoCopyWithImpl<_NetworkInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_NetworkInfoToJson(this);
  }
}

abstract class _NetworkInfo extends NetworkInfo {
  const factory _NetworkInfo(
      {int? chainID,
      String? networkID,
      String? nodeProviderUrl,
      String? blockExplorerUrl,
      String? blockExplorerNetwork}) = _$_NetworkInfo;
  const _NetworkInfo._() : super._();

  factory _NetworkInfo.fromJson(Map<String, dynamic> json) =
      _$_NetworkInfo.fromJson;

  @override
  int? get chainID => throw _privateConstructorUsedError;
  @override
  String? get networkID => throw _privateConstructorUsedError;
  @override
  String? get nodeProviderUrl => throw _privateConstructorUsedError;
  @override
  String? get blockExplorerUrl => throw _privateConstructorUsedError;
  @override
  String? get blockExplorerNetwork => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NetworkInfoCopyWith<_NetworkInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
