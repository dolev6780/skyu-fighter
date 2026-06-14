import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flame_game/main.dart';

void main() {
  testWidgets('Aero Fighter Game App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AeroFighterApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Either the overlays are rendered or the game app is present
    expect(find.byType(AeroFighterApp), findsOneWidget);
  });
}
