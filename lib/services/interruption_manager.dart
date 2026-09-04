import 'dart:math';

class MaxMindService {
  final Random _random = Random();

  final List<String> _welcomeMessages = [
    "Welcome to The MAX AI Ecosystem.",
    "It's great to have you here.",
    "Let's build something amazing together.",
    "I'm glad you're here.",
  ];

  final List<String> _nameResponses = [
    "Nice name you've got there, {name}.",
    "It's great to meet you, {name}.",
    "{name}... I like that.",
    "Welcome, {name}.",
    "Glad you're here, {name}.",
    "That's a memorable name, {name}.",
    "Looking forward to getting to know you, {name}.",
  ];

  final List<String> _goodbyeResponses = [
    "See you soon.",
    "Take care.",
    "I'll be here when you need me.",
  ];

  String welcome() {
    return _welcomeMessages[
        _random.nextInt(_welcomeMessages.length)];
  }

  String greetUser(String name) {
    return _nameResponses[
            _random.nextInt(_nameResponses.length)]
        .replaceAll("{name}", name);
  }

  String goodbye() {
    return _goodbyeResponses[
        _random.nextInt(_goodbyeResponses.length)];
  }

  String thinkingMessage() {
    const messages = [
      "Thinking...",
      "Let me figure that out...",
      "Working on it...",
    ];

    return messages[
        _random.nextInt(messages.length)];
  }
}