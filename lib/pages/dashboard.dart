import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userprovider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Total Savings'),
            subtitle: Text(userProvider.totalSavings.toString()),
          ),
          ListTile(
            title: Text('Total Target'),
            subtitle: Text(userProvider.totalTarget.toString()),
          ),
          ListTile(
            title: Text('Total Achieved'),
            subtitle: Text(userProvider.totalAchieved.toString()),
          ),
          ListTile(
            title: Text('Total Balance'),
            subtitle: Text(userProvider.totalBalance.toString()),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userProvider.goals.length,
              itemBuilder: (context, index) {
                final goal = userProvider.goals[index];
                return ListTile(
                  title: Text(goal.target),
                  subtitle: Text(
                      'Amount: ${goal.amount}\nAchieved: ${goal.achieved}\nBalance: ${goal.balance}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
