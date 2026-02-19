import 'package:flutter/material.dart';
import 'grpmodel.dart';
import 'dummydata.dart';
import 'addexpense.dart';

class SettlementPage extends StatefulWidget {
  final GroupModel group;

  const SettlementPage({Key? key, required this.group})
      : super(key: key);

  @override
  State<SettlementPage> createState() =>
      _SettlementPageState();
}

class _SettlementPageState
    extends State<SettlementPage>
    with SingleTickerProviderStateMixin {
  final Color primaryPurple =
  const Color(0xFF982598);
  final Color softPink =
  const Color(0xFFE491C9);
  final Color lightBg =
  const Color(0xFFF7F2F8);

  final String currentUserId = "you";

  late TabController _tabController;

  List<ExpenseModel> expenses = [];
  Map<String, double> youOweMap = {};
  Map<String, double> oweYouMap = {};

  bool isAdmin = true;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this);
    _refreshData();
  }

  void _refreshData() {
    expenses =
        groupExpenses[widget.group.id] ?? [];
    _calculateBalances();
  }

  void _calculateBalances() {
    youOweMap.clear();
    oweYouMap.clear();

    for (var expense in expenses) {
      double split =
          expense.amount /
              expense.participants.length;

      for (var member
      in expense.participants) {
        if (member ==
            expense.paidByName) continue;

        if (expense.paidByName ==
            currentUserId) {
          oweYouMap[member] =
              (oweYouMap[member] ?? 0) +
                  split;
        } else if (member ==
            currentUserId) {
          youOweMap[expense.paidByName] =
              (youOweMap[
              expense.paidByName] ??
                  0) +
                  split;
        }
      }
    }

    setState(() {});
  }

  double get totalYouOwe =>
      youOweMap.values
          .fold(0, (a, b) => a + b);

  double get totalOweYou =>
      oweYouMap.values
          .fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    double net =
        totalOweYou - totalYouOwe;

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor:
        primaryPurple,
        title: Text(widget.group.name),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor:
        primaryPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Expense",
          style:
          TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddExpensePage(),
            ),
          ).then((_) {
            _refreshData();
          });
        },
      ),

      body: Column(
        children: [

          /// BALANCE CARD
          Container(
            margin:
            const EdgeInsets.all(20),
            padding:
            const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryPurple,
                  softPink
                ],
              ),
              borderRadius:
              BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                const Text(
                  "Group Balance",
                  style: TextStyle(
                      color:
                      Colors.white70),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    _balanceColumn(
                        "You Owe",
                        totalYouOwe),
                    Container(
                      height: 40,
                      width: 1,
                      color:
                      Colors.white38,
                    ),
                    _balanceColumn(
                        "You Are Owed",
                        totalOweYou),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(
                    color:
                    Colors.white38),
                const SizedBox(height: 10),
                Text(
                  "Net Balance: ${net >= 0 ? "+" : "-"} ₹ ${net.abs().toStringAsFixed(0)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w600),
                ),
              ],
            ),
          ),

          /// SETTLE ALL BUTTON
          if (isAdmin)
            Padding(
              padding:
              const EdgeInsets.symmetric(
                  horizontal: 20),
              child: Container(
                height: 50,
                decoration:
                BoxDecoration(
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF7B1FA2),
                      Color(0xFF982598),
                    ],
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(14),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(
                      Icons.handshake,
                      color:
                      Colors.white),
                  label: const Text(
                    "Settle All Balances",
                    style: TextStyle(
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight.bold),
                  ),
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    Colors
                        .transparent,
                    shadowColor:
                    Colors
                        .transparent,
                  ),
                  onPressed: () {
                    youOweMap.clear();
                    oweYouMap.clear();
                    setState(() {});
                  },
                ),
              ),
            ),

          const SizedBox(height: 10),

          TabBar(
            controller: _tabController,
            labelColor: primaryPurple,
            indicatorColor:
            primaryPurple,
            tabs: const [
              Tab(text: "All"),
              Tab(text: "I Owe"),
              Tab(text: "Owe Me"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller:
              _tabController,
              children: [
                _allTab(),
                _iOweTab(),
                _oweMeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceColumn(
      String title,
      double amount) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
            const TextStyle(
                color: Colors
                    .white70)),
        const SizedBox(height: 5),
        Text(
            "₹ ${amount.toStringAsFixed(0)}",
            style:
            const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight
                    .bold,
                color:
                Colors.white)),
      ],
    );
  }

  Widget _allTab() {
    if (expenses.isEmpty) {
      return const Center(
          child: Text(
              "No expenses yet"));
    }

    return ListView.builder(
      padding:
      const EdgeInsets.all(15),
      itemCount: expenses.length,
      itemBuilder:
          (context, index) {
        final exp = expenses[index];

        return Container(
          margin:
          const EdgeInsets.only(
              bottom: 15),
          padding:
          const EdgeInsets.all(
              18),
          decoration:
          BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius
                .circular(18),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  Text(exp.title,
                      style:
                      const TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize:
                          16)),
                  Text(
                    "₹ ${exp.amount.toStringAsFixed(0)}",
                    style:
                    TextStyle(
                      color:
                      primaryPurple,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                  height: 8),
              Text(
                  "Category: ${exp.category}"),
              if (exp.category ==
                  "Other")
                Text(
                    "Desc: ${exp.description}"),
              Text(
                  "Paid by: ${exp.paidByName}"),
              Text(
                  "Date: ${exp.date.day}/${exp.date.month}/${exp.date.year}"),
              Text(
                  "Split between: ${exp.participants.join(", ")}"),
            ],
          ),
        );
      },
    );
  }

  Widget _iOweTab() {
    if (youOweMap.isEmpty) {
      return const Center(
          child: Text(
              "You owe nothing 🎉"));
    }

    return ListView(
      padding:
      const EdgeInsets.all(15),
      children:
      youOweMap.entries
          .map((e) =>
          _personCard(
              e.key,
              e.value,
              true))
          .toList(),
    );
  }

  Widget _oweMeTab() {
    if (oweYouMap.isEmpty) {
      return const Center(
          child: Text(
              "No one owes you"));
    }

    return ListView(
      padding:
      const EdgeInsets.all(15),
      children:
      oweYouMap.entries
          .map((e) =>
          _personCard(
              e.key,
              e.value,
              false))
          .toList(),
    );
  }

  Widget _personCard(
      String name,
      double amount,
      bool isOwe) {
    return Container(
      margin:
      const EdgeInsets.only(
          bottom: 12),
      padding:
      const EdgeInsets.all(16),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
            16),
      ),
      child: Row(
        children: [
          const CircleAvatar(),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(name,
                    style:
                    const TextStyle(
                        fontWeight:
                        FontWeight
                            .bold)),
                Text(
                  "₹ ${amount.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: isOwe
                        ? Colors.red
                        : Colors.green,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isOwe)
            ElevatedButton(
              style:
              ElevatedButton
                  .styleFrom(
                backgroundColor:
                primaryPurple,
                foregroundColor:
                Colors.white,
              ),
              onPressed: () {},
              child:
              const Text("Pay"),
            )
        ],
      ),
    );
  }
}
