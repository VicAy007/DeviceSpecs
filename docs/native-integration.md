# Native Integration — system_info

This document lists the native `MethodChannel` handlers that the Dart-side
services in `lib/services/native/` expect. Until these are implemented on
each platform, every call falls through `MissingPluginException` and the
corresponding field is shown as **"Not supported"** — the app never crashes
and never fabricates a value.

## `com.devicespecs/device`

| Method | Android (Kotlin) | iOS (Swift) |
|---|---|---|
| `getSupportedAbis` | `Build.SUPPORTED_ABIS.toList()` | `[String(cString: uts.machine)]` via `uname` |
| `isPhysicalDevice` | check `Build.FINGERPRINT.contains("generic")` | `TARGET_OS_SIMULATOR` compile flag |

```kotlin
// MainActivity.kt
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.devicespecs/device")
    .setMethodCallHandler { call, result ->
        when (call.method) {
            "getSupportedAbis" -> result.success(Build.SUPPORTED_ABIS.toList())
            "isPhysicalDevice" -> result.success(!Build.FINGERPRINT.contains("generic"))
            else -> result.notImplemented()
        }
    }
```

## `com.devicespecs/battery`

| Method | Android (Kotlin) | iOS (Swift) |
|---|---|---|
| `getPowerSource` | `BatteryManager` broadcast extra `BatteryManager.EXTRA_PLUGGED` mapped to AC/USB/Wireless | Not exposed by public iOS APIs → return `nil` so Dart reports `Unavailable` |

```kotlin
"getPowerSource" -> {
    val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    val plugged = intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1) ?: -1
    result.success(when (plugged) {
        BatteryManager.BATTERY_PLUGGED_AC -> "AC"
        BatteryManager.BATTERY_PLUGGED_USB -> "USB"
        BatteryManager.BATTERY_PLUGGED_WIRELESS -> "Wireless"
        else -> null
    })
}
```

## `com.devicespecs/storage`

| Method | Android (Kotlin) | iOS (Swift) |
|---|---|---|
| `getTotalStorageBytes` | `StatFs(dataDir.path).totalBytes` | `URLResourceValues.volumeTotalCapacity` |
| `getFreeStorageBytes` | `StatFs(dataDir.path).availableBytes` | `URLResourceValues.volumeAvailableCapacityForImportantUsage` |

```swift
// AppDelegate.swift
let channel = FlutterMethodChannel(name: "com.devicespecs/storage", binaryMessenger: controller.binaryMessenger)
channel.setMethodCallHandler { call, result in
    let url = URL(fileURLWithPath: NSHomeDirectory())
    switch call.method {
    case "getTotalStorageBytes":
        let values = try? url.resourceValues(forKeys: [.volumeTotalCapacityKey])
        result(values?.volumeTotalCapacity ?? -1)
    case "getFreeStorageBytes":
        let values = try? url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        result(values?.volumeAvailableCapacityForImportantUsage ?? -1)
    default:
        result(FlutterMethodNotImplemented)
    }
}
```

## `com.devicespecs/system`

| Method | Android (Kotlin) | iOS (Swift) |
|---|---|---|
| `getGpuRenderer` / `getGpuVendor` | query `GLES20.glGetString` from a throwaway `EGL` context | `MTLCreateSystemDefaultDevice()?.name` |
| `getGraphicsApi` | `"OpenGL ES"` or `"Vulkan"` depending on `PackageManager` feature flags | `"Metal"` (constant on supported devices) |
| `getCpuAbi` | `Build.SUPPORTED_ABIS.firstOrNull()` | `String(cString: uts.machine)` |

> ⚠️ GPU renderer/vendor queries touch `EGL`/`GLES` directly and are the most
> platform-fragile calls in this app. Wrap them defensively and always
> fall back to `result.success(null)` rather than throwing, so the Dart
> side reports **Unavailable** instead of crashing the channel.

---

Every handler above **must** call `result.success(null)` (not throw) when a
value cannot be determined at runtime (permission denied, feature absent on
this exact device) — reserve throwing/`MissingPluginException` for "this
platform build doesn't implement this channel at all", which the Dart side
maps to **"Not supported"**.
