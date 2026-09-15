import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory_master_app/main.dart';

void main() {
  testWidgets('dashboard shows the activity menu', (tester) async {
    await tester.pumpWidget(const LaboratoryApp());
    await tester.pumpAndSettle();
    expect(find.text('Welcome back, Scientist'), findsOneWidget);
    expect(find.text('Sample Check-in'), findsOneWidget);
    expect(find.text('Results Review'), findsOneWidget);
  });
}
