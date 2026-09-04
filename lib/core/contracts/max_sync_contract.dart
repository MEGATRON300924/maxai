/// Cloud synchronization boundary for MAX ecosystem data.
///
/// The implementation can later target Supabase or the MAX backend without
/// coupling screens to a specific persistence provider.
abstract interface class MaxSyncContract {
  Future<void> push(String collection, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> pull(String collection);
  Future<void> delete(String collection, String id);
}

class NoopMaxSyncService implements MaxSyncContract {
  @override
  Future<void> push(String collection, Map<String, dynamic> data) async {}

  @override
  Future<List<Map<String, dynamic>>> pull(String collection) async => const [];

  @override
  Future<void> delete(String collection, String id) async {}
}
