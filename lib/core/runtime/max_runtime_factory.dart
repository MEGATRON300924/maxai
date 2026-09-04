import '../contracts/max_auth_contract.dart';
import '../contracts/max_memory_contract.dart';
import '../contracts/max_subscription_contract.dart';
import '../contracts/max_sync_contract.dart';
import '../../services/max_auth_service.dart';
import 'max_runtime.dart';

/// Creates the default development runtime.
///
/// Production wiring can replace each adapter independently when MAX Auth and
/// MAX Cloud are ready. No UI surface needs to know which provider is active.
class MaxRuntimeFactory {
  const MaxRuntimeFactory._();

  static MaxRuntime create({
    MaxAuthContract? auth,
    MaxMemoryContract? memory,
    MaxSyncContract? sync,
    MaxSubscriptionContract? subscriptions,
  }) {
    return MaxRuntime(
      auth: auth ?? MaxAuthService(),
      memory: memory ?? LocalMaxMemoryAdapter(),
      sync: sync ?? NoopMaxSyncService(),
      subscriptions: subscriptions ?? DevelopmentSubscriptionService(),
    );
  }
}
