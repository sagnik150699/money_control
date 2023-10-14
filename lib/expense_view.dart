import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import 'components.dart';
import 'view_model.dart';

bool isLoading = true;

class ExpenseView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    final double categoryWidth = MediaQuery.of(context).size.width;
    if (isLoading == true) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      isLoading = false;
    }

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                //  padding: EdgeInsets.only(bottom: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0, color: Colors.black),
                  ),
                  child: SvgPicture.asset("assets/piggy2.svg", height: 100.0),
                ),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                elevation: 20.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                height: 50.0,
                minWidth: 200.0,
                color: Colors.black,
                child: OpenSans(text: "Logout", size: 20.0),
                onPressed: () async {
                  await viewModelProvider.logout();
                },
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      launchUrl(
                          Uri.parse("https://www.instagram.com/ratantata"));
                    },
                    icon: SvgPicture.asset(
                      "assets/instagram.svg",
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse("https://www.twitter.com/ratantata"));
                    },
                    icon: SvgPicture.asset(
                      "assets/twitter.svg",
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 30.0),
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Poppins(text: "Dashboard", size: 20.0),
          actions: [
            IconButton(
              onPressed: () async {
                viewModelProvider.reset();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: 40.0),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: categoryWidth / 1.3,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: TotalCalculation(),
                ),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AddExpense(),
                SizedBox(width: 10.0),
                AddIncome(),
              ],
            ),
            SizedBox(height: 30.0),
            Column(
              children: [
                OpenSans(
                    text: "Expenses",
                    fontWeight: FontWeight.bold,
                    size: 40.0,
                    color: Colors.black),
                Container(
                  padding: EdgeInsets.all(7.0),
                  height: 210.0,
                  width: categoryWidth / 1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(width: 1.0, color: Colors.black),
                  ),
                  child: ListView.builder(
                    itemCount: viewModelProvider.expenses.length,
                    itemBuilder: (BuildContext context, index) {
                      return IncomeExpenseRow(
                          text: viewModelProvider.expenses[index].name,
                          amount: viewModelProvider.expenses[index].amount);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Column(
              children: [
                OpenSans(
                    text: "Incomes",
                    fontWeight: FontWeight.bold,
                    size: 40.0,
                    color: Colors.black),
                Container(
                  padding: EdgeInsets.all(7.0),
                  height: 210.0,
                  width: categoryWidth / 1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(width: 1.0, color: Colors.black),
                  ),
                  child: ListView.builder(
                    itemCount: viewModelProvider.incomes.length,
                    itemBuilder: (BuildContext context, index) {
                      return IncomeExpenseRow(
                          text: viewModelProvider.incomes[index].name,
                          amount: viewModelProvider.incomes[index].amount);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TotalCalculation extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              text: "Budget left",
              size: 24.0,
            ),
            Poppins(
              text: "Total Expense",
              size: 24.0,
            ),
            Poppins(
              text: "Total Income",
              size: 24.0,
            ),
          ],
        ),
        RotatedBox(
            quarterTurns: 1,
            child: Divider(
              indent: 40.0,
              endIndent: 40.0,
              color: Colors.grey,
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              text: viewModelProvider.budgetLeft.toString(),
              size: 18.0,
            ),
            Poppins(
              text: viewModelProvider.totalExpense.toString(),
              size: 18.0,
            ),
            Poppins(
              text: viewModelProvider.totalIncome.toString(),
              size: 18.0,
            ),
          ],
        )
      ],
    );
  }
}

class AddExpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 45.0,
      width: 160.0,
      child: MaterialButton(
        splashColor: Colors.grey,
        color: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            OpenSans(
              text: "Add Expense",
              size: 17.0,
            )
          ],
        ),
        onPressed: () async {
          await viewModelProvider.addExpense(context);
        },
      ),
    );
  }
}

class AddIncome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 45.0,
      width: 160.0,
      child: MaterialButton(
        splashColor: Colors.grey,
        color: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            OpenSans(
              text: "Add Income",
              size: 17.0,
            )
          ],
        ),
        onPressed: () async {
          await viewModelProvider.addIncome(context);
        },
      ),
    );
  }
}
