import 'package:flutter_test/flutter_test.dart';
import 'package:studyspark/main.dart';

void main() {
  testWidgets('StudySpark loads', (WidgetTester tester) async {
    await tester.pumpWidget(const StudySpark());
    expect(find.byType(StudySpark), findsOneWidget);
  });
}
