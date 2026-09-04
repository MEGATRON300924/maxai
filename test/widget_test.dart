import 'package:flutter_test/flutter_test.dart';

import 'package:maxai/main.dart';

void main() {
  testWidgets('MAX AI app boots', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaxAIApp(chatService: throw UnsupportedError('not wired in smoke test')),
    );
  });
}
