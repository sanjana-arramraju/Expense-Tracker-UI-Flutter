
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_dart_files/main.dart';

void main() {
  testWidgets('Expense Tracker app loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    // Check that the home screen is displayed.
    expect(find.text('My Expenses'), findsOneWidget);

    // Check the total spending section.
    expect(find.text('Total spending'), findsOneWidget);

    // Check the initial transaction count.
    expect(find.text('3 transaction(s) recorded'), findsOneWidget);

    // Check the initial total: 850 + 450 + 120.
    expect(find.text('₹1420.00'), findsOneWidget);
  });
}