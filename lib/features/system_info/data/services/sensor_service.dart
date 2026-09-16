import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../../core/utils/sys_value.dart';
import '../../domain/entities/sensor_info.dart';

/// `sensors_plus` exposes event streams but no direct "is X sensor present"
/// API, so availability is inferred by listening briefly for at least one
/// event. If the platform genuinely lacks the sensor, the stream stays
/// silent and we time out — reported as `Unavailable` rather than guessed.
class SensorService {
  const SensorService({this.probeTimeout = const Duration(milliseconds: 400)});

  final Duration probeTimeout;

  Future<SensorInfo> getSensorInfo() async {
    final results = await Future.wait([
      _probe(accelerometerEventStream()),
      _probe(gyroscopeEventStream()),
      _probe(magnetometerEventStream()),
      _probeProximity(),
    ]);

    return SensorInfo(
      hasAccelerometer: results[0],
      hasGyroscope: results[1],
      hasMagnetometer: results[2],
      hasProximity: results[3],
    );
  }

  Future<SysValue<bool>> _probe(Stream<dynamic> stream) async {
    try {
      final completer = Completer<SysValue<bool>>();
      late final StreamSubscription sub;
      sub = stream.listen(
        (_) {
          if (!completer.isCompleted) completer.complete(const SysValue.available(true));
          sub.cancel();
        },
        onError: (_) {
          if (!completer.isCompleted) completer.complete(const SysValue.unavailable());
          sub.cancel();
        },
      );
      return await completer.future.timeout(
        probeTimeout,
        onTimeout: () {
          sub.cancel();
          return const SysValue.unavailable();
        },
      );
    } catch (_) {
      return const SysValue.notSupported();
    }
  }

  /// Proximity has no dedicated stream in `sensors_plus`; it is commonly
  /// exposed only via a native channel or a dedicated package. We report it
  /// as not supported until wired to a native implementation.
  Future<SysValue<bool>> _probeProximity() async {
    return const SysValue.notSupported();
  }
}
