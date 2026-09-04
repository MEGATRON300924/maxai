import 'max_runtime.dart';
import 'max_runtime_factory.dart';

/// Process-wide MAX runtime scope.
///
/// This is intentionally a small composition root. Feature services can share
/// the same runtime instance instead of silently creating separate memory,
/// auth, and subscription state.
class MaxRuntimeScope {
  MaxRuntimeScope._();

  static final MaxRuntimeScope instance = MaxRuntimeScope._();

  MaxRuntime? _runtime;

  MaxRuntime get runtime => _runtime ??= MaxRuntimeFactory.create();

  Future<MaxRuntime> initialize() async {
    final value = runtime;
    await value.initialize();
    return value;
  }

  void configure(MaxRuntime value) {
    if (_runtime != null) {
      throw StateError('MAX runtime has already been configured.');
    }
    _runtime = value;
  }
}
