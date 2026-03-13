import 'package:flutter_test/flutter_test.dart';
import 'package:amin_gide/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {

    await tester.pumpWidget(AmunGuideApp());

    expect(find.byType(AmunGuideApp), findsOneWidget);
  });
}
