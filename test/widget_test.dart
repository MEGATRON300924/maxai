import 'package:flutter_test/flutter_test.dart';

import 'package:maxai/main.dart';
import 'package:maxai/services/chat_service.dart';
import 'package:maxai/services/gemini_service.dart';
import 'package:maxai/services/max_ai_brain.dart';
import 'package:maxai/services/max_auth_service.dart';

void main() {
  testWidgets('MAX AI app boots', (WidgetTester tester) async {
    final brain = MaxAIBrain(
      gemini: GeminiService(apiKey: ''),
      auth: MaxAuthService(),
    );

    await tester.pumpWidget(
      MaxAIApp(chatService: ChatService(brain: brain)),
    );
    await tester.pump();

    expect(find.byType(MaxAIApp), findsOneWidget);
  });
}
