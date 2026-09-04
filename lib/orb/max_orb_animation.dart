import '../models/max_orb_state.dart';

enum MaxOrbAnimationType {
  breathing,
  waveform,
  liquid,
  pulse,
  ripple,
  heartbeat,
  rotation,
  sleeping,
  none,
}

class MaxOrbAnimationConfig {
  final MaxOrbAnimationType type;
  final Duration duration;
  final double intensity;

  const MaxOrbAnimationConfig({
    required this.type,
    required this.duration,
    required this.intensity,
  });

  factory MaxOrbAnimationConfig.fromState(MaxOrbState state) {
    switch (state) {
      case MaxOrbState.idle:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.breathing, duration: Duration(seconds: 4), intensity: .35);
      case MaxOrbState.listening:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.waveform, duration: Duration(milliseconds: 900), intensity: .85);
      case MaxOrbState.thinking:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.liquid, duration: Duration(seconds: 3), intensity: .65);
      case MaxOrbState.speaking:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.pulse, duration: Duration(milliseconds: 700), intensity: .8);
      case MaxOrbState.success:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.ripple, duration: Duration(seconds: 2), intensity: .5);
      case MaxOrbState.warning:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.pulse, duration: Duration(seconds: 1), intensity: .8);
      case MaxOrbState.error:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.ripple, duration: Duration(milliseconds: 600), intensity: 1);
      case MaxOrbState.offline:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.breathing, duration: Duration(seconds: 5), intensity: .2);
      case MaxOrbState.wakeDetected:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.ripple, duration: Duration(milliseconds: 500), intensity: 1);
      case MaxOrbState.sos:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.heartbeat, duration: Duration(milliseconds: 700), intensity: 1);
      case MaxOrbState.syncing:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.rotation, duration: Duration(seconds: 2), intensity: .6);
      case MaxOrbState.sleep:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.sleeping, duration: Duration(seconds: 6), intensity: .15);
      case MaxOrbState.updating:
        return const MaxOrbAnimationConfig(type: MaxOrbAnimationType.rotation, duration: Duration(seconds: 2), intensity: .7);
    }
  }
}
