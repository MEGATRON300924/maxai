import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/contracts/max_sync_contract.dart';

/// Offline-first synchronization wrapper for the MAX ecosystem.
///
/// Writes are attempted against the real sync adapter first. If the adapter is
/// unavailable, the operation is persisted locally and can be replayed later.
/// This keeps the app usable while MAX Cloud/Supabase is unavailable.
class QueuedMaxSyncService implements MaxSyncContract {
  QueuedMaxSyncService({
    required MaxSyncContract remote,
    SharedPreferences? preferences,
  })  : _remote = remote,
        _preferences = preferences;

  static const _queueKey = 'max_sync_queue_v1';

  final MaxSyncContract _remote;
  SharedPreferences? _preferences;
  final List<_PendingSyncOperation> _queue = [];
  bool _loaded = false;

  int get pendingCount => _queue.length;

  Future<void> initialize() async {
    await _loadQueue();
  }

  @override
  Future<void> push(String collection, Map<String, dynamic> data) async {
    await _loadQueue();
    final operation = _PendingSyncOperation.push(collection, data);

    try {
      await _remote.push(collection, data);
      await _removeMatching(operation);
    } catch (_) {
      await _enqueue(operation);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> pull(String collection) async {
    await _loadQueue();
    try {
      return await _remote.pull(collection);
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> delete(String collection, String id) async {
    await _loadQueue();
    final operation = _PendingSyncOperation.delete(collection, id);

    try {
      await _remote.delete(collection, id);
      await _removeMatching(operation);
    } catch (_) {
      await _enqueue(operation);
    }
  }

  /// Replays queued operations in order.
  ///
  /// Failed operations remain queued so a temporary outage does not lose data.
  Future<int> flush() async {
    await _loadQueue();
    var flushed = 0;

    for (final operation in List<_PendingSyncOperation>.from(_queue)) {
      try {
        if (operation.type == _PendingSyncOperationType.push) {
          await _remote.push(operation.collection, operation.data!);
        } else {
          await _remote.delete(operation.collection, operation.id!);
        }

        _queue.remove(operation);
        flushed++;
      } catch (_) {
        // Keep this and all following operations for the next retry.
        break;
      }
    }

    await _persistQueue();
    return flushed;
  }

  Future<void> _loadQueue() async {
    if (_loaded) return;
    _preferences ??= await SharedPreferences.getInstance();

    final raw = _preferences!.getString(_queueKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _queue
            ..clear()
            ..addAll(
              decoded
                  .whereType<Map>()
                  .map((item) => _PendingSyncOperation.fromJson(Map<String, dynamic>.from(item)))
                  .where((operation) => operation.collection.isNotEmpty),
            );
        }
      } catch (_) {
        _queue.clear();
      }
    }

    _loaded = true;
  }

  Future<void> _enqueue(_PendingSyncOperation operation) async {
    // Collapse an identical pending operation instead of growing the queue
    // when the same write is retried repeatedly while offline.
    _queue.removeWhere((existing) => existing.sameTarget(operation));
    _queue.add(operation);
    await _persistQueue();
  }

  Future<void> _removeMatching(_PendingSyncOperation operation) async {
    _queue.removeWhere((existing) => existing.sameTarget(operation));
    await _persistQueue();
  }

  Future<void> _persistQueue() async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.setString(
      _queueKey,
      jsonEncode(_queue.map((operation) => operation.toJson()).toList()),
    );
  }
}

enum _PendingSyncOperationType { push, delete }

class _PendingSyncOperation {
  const _PendingSyncOperation._({
    required this.type,
    required this.collection,
    this.data,
    this.id,
  });

  const _PendingSyncOperation.push(
    String collection,
    Map<String, dynamic> data,
  ) : this._(
          type: _PendingSyncOperationType.push,
          collection: collection,
          data: data,
        );

  const _PendingSyncOperation.delete(String collection, String id)
      : this._(
          type: _PendingSyncOperationType.delete,
          collection: collection,
          id: id,
        );

  final _PendingSyncOperationType type;
  final String collection;
  final Map<String, dynamic>? data;
  final String? id;

  factory _PendingSyncOperation.fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString();
    if (type == 'delete') {
      return _PendingSyncOperation.delete(
        json['collection']?.toString() ?? '',
        json['id']?.toString() ?? '',
      );
    }

    return _PendingSyncOperation.push(
      json['collection']?.toString() ?? '',
      Map<String, dynamic>.from(json['data'] as Map? ?? const {}),
    );
  }

  bool sameTarget(_PendingSyncOperation other) {
    if (type != other.type || collection != other.collection) return false;
    return type == _PendingSyncOperationType.delete
        ? id == other.id
        : data?['id']?.toString() == other.data?['id']?.toString();
  }

  Map<String, dynamic> toJson() => {
        'type': type == _PendingSyncOperationType.push ? 'push' : 'delete',
        'collection': collection,
        if (data != null) 'data': data,
        if (id != null) 'id': id,
      };
}
