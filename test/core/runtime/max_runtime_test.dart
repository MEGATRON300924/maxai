import 'package:flutter_test/flutter_test.dart';

import 'package:maxai/core/contracts/max_auth_contract.dart';
import 'package:maxai/core/contracts/max_memory_contract.dart';
import 'package:maxai/core/contracts/max_subscription_contract.dart';
import 'package:maxai/core/contracts/max_sync_contract.dart';
import 'package:maxai/core/runtime/max_runtime.dart';

void main() {
  test('initializes shared services and exposes a runtime snapshot', () async {
    final auth = _FakeAuth();
    final memory = _FakeMemory();
    final sync = _FakeSync();
    final subscriptions = _FakeSubscriptions();
    final runtime = MaxRuntime(
      auth: auth,
      memory: memory,
      sync: sync,
      subscriptions: subscriptions,
    );

    await runtime.initialize();
    final snapshot = await runtime.snapshot();

    expect(memory.initialized, isTrue);
    expect(subscriptions.refreshed, isTrue);
    expect(auth.refreshed, isTrue);
    expect(snapshot.authenticated, isTrue);
    expect(snapshot.userId, 'test-user');
    expect(snapshot.plan, MaxPlan.pro);
    expect(snapshot.memoryCount, 2);
  });
}

class _FakeAuth implements MaxAuthContract {
  bool refreshed = false;

  @override
  bool get isAuthenticated => true;

  @override
  Future<MaxAuthUser?> currentUser() async =>
      const MaxAuthUser(id: 'test-user', email: 'test@example.com');

  @override
  Future<MaxAuthResult> refreshSession() async {
    refreshed = true;
    return MaxAuthResult.success(user: await currentUser());
  }

  @override
  Future<MaxAuthResult> signIn({required String email, required String password}) =>
      Future.value(MaxAuthResult.success(user: await currentUser()));

  @override
  Future<MaxAuthResult> signUp({required String email, required String password}) =>
      Future.value(MaxAuthResult.success(user: await currentUser()));

  @override
  Future<void> signOut() async {}
}

class _FakeMemory implements MaxMemoryContract {
  bool initialized = false;
  final _items = <MaxMemory>[];

  _FakeMemory() {
    final now = DateTime(2026, 1, 1);
    _items.addAll([
      MaxMemory(
        id: '1',
        content: 'one',
        category: 'test',
        createdAt: now,
        updatedAt: now,
        importance: 1,
        tags: const [],
      ),
      MaxMemory(
        id: '2',
        content: 'two',
        category: 'test',
        createdAt: now,
        updatedAt: now,
        importance: 0.8,
        tags: const [],
      ),
    ]);
  }

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  List<MaxMemory> get memories => List.unmodifiable(_items);

  @override
  List<MaxMemory> get importantMemories =>
      _items.where((item) => item.importance >= 0.7).toList();

  @override
  Future<MaxMemory?> save({
    required String content,
    String category = 'general',
    double importance = 0.5,
    List<String> tags = const [],
  }) async => null;

  @override
  List<MaxMemory> search(String query, {int limit = 20}) => const [];

  @override
  List<MaxMemory> relevantMemories(String query, {int limit = 8}) => const [];

  @override
  String buildMemoryContext(String query, {int limit = 8}) => '';

  @override
  Future<bool> update(
    String id, {
    String? content,
    String? category,
    double? importance,
    List<String>? tags,
  }) async => false;

  @override
  Future<bool> delete(String id) async => false;

  @override
  Future<void> clear({bool keepImportant = true}) async {}

  @override
  Future<void> importMemories(List<Map<String, dynamic>> data) async {}

  @override
  List<Map<String, dynamic>> exportMemories() => const [];
}

class _FakeSync implements MaxSyncContract {
  @override
  Future<void> push(String collection, Map<String, dynamic> data) async {}

  @override
  Future<List<Map<String, dynamic>>> pull(String collection) async => const [];

  @override
  Future<void> delete(String collection, String id) async {}
}

class _FakeSubscriptions implements MaxSubscriptionContract {
  bool refreshed = false;

  @override
  MaxPlan get currentPlan => MaxPlan.pro;

  @override
  bool hasFeature(String feature) => true;

  @override
  Future<void> refresh() async {
    refreshed = true;
  }
}
