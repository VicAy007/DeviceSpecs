import '../../../../services/native/storage_platform_service.dart';
import '../../domain/entities/storage_info.dart';

/// Storage totals are only obtainable natively (there is no maintained,
/// permission-free Flutter package returning raw free/total bytes on both
/// platforms), so this service simply delegates to the native channel.
class StorageService {
  StorageService({StoragePlatformService? storagePlatformService})
      : _storagePlatformService = storagePlatformService ?? StoragePlatformService();

  final StoragePlatformService _storagePlatformService;

  Future<StorageInfo> getStorageInfo() async {
    final total = await _storagePlatformService.getTotalStorageBytes();
    final free = await _storagePlatformService.getFreeStorageBytes();
    return StorageInfo(totalBytes: total, freeBytes: free);
  }
}
