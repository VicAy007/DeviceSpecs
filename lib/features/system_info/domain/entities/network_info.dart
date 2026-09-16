import '../../../../core/utils/sys_value.dart';

/// Current connectivity snapshot.
class NetworkInfo {
  const NetworkInfo({
    required this.connectionType,
    required this.isConnected,
  });

  final SysValue<String> connectionType;
  final SysValue<bool> isConnected;

  factory NetworkInfo.loading() => const NetworkInfo(
        connectionType: SysValue.unknown(),
        isConnected: SysValue.unknown(),
      );
}
