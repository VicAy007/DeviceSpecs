import 'package:flutter_test/flutter_test.dart';
import 'package:device_specs/core/utils/sys_value.dart';

void main() {
  group('SysValue', () {
    test('available value displays its own toString by default', () {
      const value = SysValue<int>.available(42);
      expect(value.isAvailable, isTrue);
      expect(value.display(), '42');
    });

    test('available value can be formatted with a custom formatter', () {
      const value = SysValue<int>.available(87);
      expect(value.display((v) => '$v%'), '87%');
    });

    test('unavailable/notSupported/restricted/unknown never fabricate a value', () {
      expect(const SysValue<int>.unavailable().display(), 'Unavailable');
      expect(const SysValue<int>.notSupported().display(), 'Not supported');
      expect(const SysValue<int>.restricted().display(), 'Restricted');
      expect(const SysValue<int>.unknown().display(), 'Unknown');
    });

    test('isAvailable is false for every non-available status', () {
      expect(const SysValue<int>.unavailable().isAvailable, isFalse);
      expect(const SysValue<int>.notSupported().isAvailable, isFalse);
      expect(const SysValue<int>.restricted().isAvailable, isFalse);
      expect(const SysValue<int>.unknown().isAvailable, isFalse);
    });

    test('map preserves availability status and transforms the value', () {
      const available = SysValue<int>.available(2);
      final mapped = available.map((v) => v * 10);
      expect(mapped.isAvailable, isTrue);
      expect(mapped.value, 20);

      const unavailable = SysValue<int>.unavailable();
      final mappedUnavailable = unavailable.map((v) => v * 10);
      expect(mappedUnavailable.isAvailable, isFalse);
      expect(mappedUnavailable.display(), 'Unavailable');
    });
  });
}
