import 'package:flutter/material.dart';
import 'models/expense.dart';
import 'widgets/expenses_chart.dart';
import 'widgets/new_expense.dart';
import 'widgets/expenses_list.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7F5FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F5FC),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const ExpensesHomePage(),
    );
  }
}

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Groceries',
      amount: 850,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: ExpenseCategory.food,
    ),
    Expense(
      title: 'Bus pass',
      amount: 450,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: ExpenseCategory.travel,
    ),
    Expense(
      title: 'Notebook',
      amount: 120,
      date: DateTime.now(),
      category: ExpenseCategory.shopping,
    ),
  ];

  double get _totalExpenses =>
      _expenses.fold(0, (sum, expense) => sum + expense.amount);

  void _openAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => NewExpenseSheet(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final removedIndex = _expenses.indexOf(expense);
    setState(() {
      _expenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(removedIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentExpenses = [..._expenses]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Expenses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpense,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add expense',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpense,
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total spending',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${_totalExpenses.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_expenses.length} transaction(s) recorded',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Last 7 days',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ExpensesChart(expenses: _expenses),
              const SizedBox(height: 16),
              const Text(
                'Recent transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: recentExpenses.isEmpty
                    ? const Center(
                        child: Text('No expenses yet. Add your first expense!'),
                      )
                    : ExpensesList(
                        expenses: recentExpenses,
                        onRemoveExpense: _removeExpense,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
