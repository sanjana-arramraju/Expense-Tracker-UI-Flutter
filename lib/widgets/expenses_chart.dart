import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpensesChart extends StatelessWidget {
  const ExpensesChart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<double> get _dailyTotals {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - index));

      return expenses
          .where((expense) =>
              expense.date.year == day.year &&
              expense.date.month == day.month &&
              expense.date.day == day.day)
          .fold<double>(0, (sum, expense) => sum + expense.amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totals = _dailyTotals;
    final maxTotal = totals.fold<double>(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
        child: SizedBox(
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final barHeight = maxTotal == 0
                  ? 5.0
                  : (totals[index] / maxTotal * 78).clamp(5.0, 78.0);
              final date = DateTime.now().subtract(Duration(days: 6 - index));
              const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final dayLabel = weekdays[date.weekday - 1];

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        totals[index] == 0
                            ? ''
                            : totals[index].toStringAsFixed(0),
                        style: const TextStyle(fontSize: 9, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(dayLabel, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
