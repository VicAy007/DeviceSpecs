/// Represents the availability state of a single piece of system information.
///
/// System data can be missing for many legitimate reasons (unsupported OS
/// version, missing permission, manufacturer restriction, sandboxed API on
/// iOS, ...). We never guess or fabricate a value: every field that comes
/// from hardware/OS is wrapped in a [SysValue] so the UI can render an
/// explicit state instead of a wrong number.
enum InfoAvailability {
  available,
  unavailable,
  notSupported,
  restricted,
  unknown,
}

/// A typed wrapper around a piece of system information that may or may not
/// be available on the current device/platform/OS version.
class SysValue<T> {
  final T? value;
  final InfoAvailability status;

  const SysValue._(this.value, this.status);

  const SysValue.available(T value) : this._(value, InfoAvailability.available);
  const SysValue.unavailable() : this._(null, InfoAvailability.unavailable);
  const SysValue.notSupported() : this._(null, InfoAvailability.notSupported);
  const SysValue.restricted() : this._(null, InfoAvailability.restricted);
  const SysValue.unknown() : this._(null, InfoAvailability.unknown);

  bool get isAvailable => status == InfoAvailability.available && value != null;

  /// Human readable label used across the app for the "not available" states.
  static String labelFor(InfoAvailability status) {
    switch (status) {
      case InfoAvailability.available:
        return 'Unknown';
      case InfoAvailability.unavailable:
        return 'Unavailable';
      case InfoAvailability.notSupported:
        return 'Not supported';
      case InfoAvailability.restricted:
        return 'Restricted';
      case InfoAvailability.unknown:
        return 'Unknown';
    }
  }

  /// Renders the value for display, optionally through [formatter].
  /// Falls back to the appropriate placeholder label when unavailable.
  String display([String Function(T value)? formatter]) {
    if (isAvailable) {
      final v = value as T;
      return formatter != null ? formatter(v) : v.toString();
    }
    return SysValue.labelFor(status);
  }

  /// Maps the wrapped value while preserving the availability status.
  SysValue<R> map<R>(R Function(T value) transform) {
    if (isAvailable) {
      return SysValue<R>.available(transform(value as T));
    }
    return SysValue<R>._(null, status);
  }

  @override
  String toString() => display();
}
