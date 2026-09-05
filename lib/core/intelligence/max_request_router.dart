import 'max_intent.dart';

class MaxRoute {
  const MaxRoute({
    required this.intent,
    required this.confidence,
    required this.requiresTool,
  });

  final MaxIntent intent;
  final double confidence;
  final bool requiresTool;
}

class MaxRequestRouter {
  const MaxRequestRouter();

  MaxRoute route(String input) {
    final message = input.trim().toLowerCase();
    if (message.isEmpty) {
      return const MaxRoute(intent: MaxIntent.chat, confidence: 1, requiresTool: false);
    }
    if (_has(message, ['remind me', 'set a reminder', 'set reminder', 'set an alarm'])) {
      return const MaxRoute(intent: MaxIntent.reminder, confidence: .98, requiresTool: true);
    }
    if (_has(message, ['generate an image', 'generate image', 'create an image', 'make an image', 'create a picture', 'draw a picture'])) {
      return const MaxRoute(intent: MaxIntent.imageGeneration, confidence: .98, requiresTool: true);
    }
    if (_has(message, ['play ', 'music', 'playlist', 'song', 'album', 'artist', 'listen to '])) {
      return const MaxRoute(intent: MaxIntent.music, confidence: .95, requiresTool: true);
    }
    if (_has(message, ['remember that', 'remember this', 'save this', 'forget that', 'forget this', 'what do you remember', 'my memories'])) {
      return const MaxRoute(intent: MaxIntent.memory, confidence: .97, requiresTool: true);
    }
    if (_has(message, ['turn on', 'turn off', 'lights', 'thermostat', 'study mode', 'worship mode', 'movie mode', 'sleep mode', 'visitor mode', 'dinner mode', 'family time', 'lock the door', 'unlock the door'])) {
      return const MaxRoute(intent: MaxIntent.home, confidence: .94, requiresTool: true);
    }
    if (_browser(message)) {
      return const MaxRoute(intent: MaxIntent.browser, confidence: .93, requiresTool: true);
    }
    if (_has(message, ['search ', 'search for ', 'look up ', 'latest news', 'latest about', 'news about', 'what happened', 'who is ', 'weather'])) {
      return const MaxRoute(intent: MaxIntent.search, confidence: .92, requiresTool: true);
    }
    return const MaxRoute(intent: MaxIntent.chat, confidence: .99, requiresTool: false);
  }

  bool _has(String message, List<String> phrases) => phrases.any(message.contains);

  bool _browser(String message) {
    if (RegExp(r'https?://|www\.').hasMatch(message)) return true;
    return _has(message, ['open youtube', 'open google', 'open website', 'open this link', 'go to ', 'browse ', 'new tab', 'close tab', 'go back', 'go forward', 'reload page', 'bookmark this', 'current webpage', 'this webpage']);
  }
}
