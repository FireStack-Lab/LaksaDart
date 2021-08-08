// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NetworkInfo _$_$_NetworkInfoFromJson(Map<String, dynamic> json) {
  return _$_NetworkInfo(
    chainID: json['chainID'] as int?,
    networkID: json['networkID'] as String?,
    nodeProviderUrl: json['nodeProviderUrl'] as String?,
    blockExplorerUrl: json['blockExplorerUrl'] as String?,
    blockExplorerNetwork: json['blockExplorerNetwork'] as String?,
  );
}

Map<String, dynamic> _$_$_NetworkInfoToJson(_$_NetworkInfo instance) =>
    <String, dynamic>{
      'chainID': instance.chainID,
      'networkID': instance.networkID,
      'nodeProviderUrl': instance.nodeProviderUrl,
      'blockExplorerUrl': instance.blockExplorerUrl,
      'blockExplorerNetwork': instance.blockExplorerNetwork,
    };
