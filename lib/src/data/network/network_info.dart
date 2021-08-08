import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_info.freezed.dart';
part 'network_info.g.dart';

@freezed
abstract class NetworkInfo implements _$NetworkInfo {
  const NetworkInfo._();

  const factory NetworkInfo(
      {int? chainID,
      String? networkID,
      String? nodeProviderUrl,
      String? blockExplorerUrl,
      String? blockExplorerNetwork}) = _NetworkInfo;

  factory NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoFromJson(json);
}
