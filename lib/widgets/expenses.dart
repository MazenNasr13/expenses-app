import 'package:expenses_app/widgets/chart/chart.dart';
import 'package:expenses_app/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenseList = [
    Expense(
        title: "travel greek",
        amount: 51.2,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: "eat baraka",
        amount: 20,
        date: DateTime.now(),
        category: Category.food)
  ];

  void _openAddExpense() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenseList.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenseList.indexOf(expense);
    setState(() {
      _registeredExpenseList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenseList.insert(expenseIndex, expense);
              });
            }),
        duration: const Duration(seconds: 3),
        content: const Text("Expense deleted"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text("No expenses found, Add some!"),
    );
    if (_registeredExpenseList.isNotEmpty) {
      mainContent = ExpensesList(
        expensesList: _registeredExpenseList,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _openAddExpense, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(children: [
              Chart(expenses: _registeredExpenseList),
              Expanded(child: mainContent),
            ])
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenseList),
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
