import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/utils/sys_value.dart';
import '../../domain/entities/network_info.dart';

class NetworkService {
  NetworkService({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<NetworkInfo> getNetworkInfo() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) {
        return const NetworkInfo(
          connectionType: SysValue.unavailable(),
          isConnected: SysValue.unavailable(),
        );
      }
      final primary = results.first;
      final isConnected = !results.contains(ConnectivityResult.none);
      return NetworkInfo(
        connectionType: SysValue.available(_label(primary)),
        isConnected: SysValue.available(isConnected),
      );
    } catch (_) {
      return const NetworkInfo(
        connectionType: SysValue.unavailable(),
        isConnected: SysValue.unavailable(),
      );
    }
  }

  String _label(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';
      case ConnectivityResult.mobile:
        return 'Mobile data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.satellite:
        // Added in connectivity_plus 7.x (Android + iOS satellite links).
        return 'Satellite';
      case ConnectivityResult.none:
        return 'No connection';
    }
  }
}
