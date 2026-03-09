import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FindMyPetApp()),
    );

    // Verify the app boots without crashing
    expect(find.byType(FindMyPetApp), findsOneWidget);
  });
}
