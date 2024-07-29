class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.name.isEmpty ? 'Guest' : userProvider.name;

    // Access updated user balance from provider
    final balance =
        userProvider.goals.fold<double>(0, (prev, goal) => prev + goal.balance);

    return Scaffold(
      // Your existing UI code
      body: Column(
        children: [
          // Your existing UI code
          Text('Balance: UGX ${balance.toStringAsFixed(0)}'),
        ],
      ),
    );
  }
}
