import 'package:flutter/material.dart';
import 'package:myapp/settlement.dart';
import 'package:myapp/grpmodel.dart';
import 'package:myapp/dummydata.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryPurple = const Color(0xFF982598);
  final Color softPink = const Color(0xFFE491C9);
  final Color lightBg = const Color(0xFFF7F2F8);

  // Placeholder values; later fetch from Firebase
  double youOwe = 650;
  double youAreOwed = 1800;

  @override
  Widget build(BuildContext context) {
    double netBalance = youAreOwed - youOwe;

    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 20),

              // 🔝 Branding + Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Safar Pay",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Split smart. Travel easy.",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=5",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const Text(
                "User Name",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // 💰 Balance Card
              _balanceCard(netBalance),

              const SizedBox(height: 30),

              // 👥 Friends Section
              const Text(
                "Friends",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    8,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: softPink.withOpacity(0.3),
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=${index + 10}",
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🏘 Groups Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Groups",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/creategrp');
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(color: primaryPurple),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ✅ Dynamic Group Tiles
              ...groups.map((group) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettlementPage(group: group),
                      ),
                    );
                  },
                  child: _groupTile(group.name, "Tap to view details"),
                );
              }).toList(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helper Widgets ----------------

  Widget _balanceCard(double netBalance) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryPurple, softPink],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Balance",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _balanceColumn("You Owe", youOwe),
              Container(
                height: 40,
                width: 1,
                color: Colors.white38,
              ),
              _balanceColumn("You Are Owed", youAreOwed),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white38),
          const SizedBox(height: 10),
          Text(
            "Net Balance: ${netBalance >= 0 ? "+" : "-"} ₹ ${netBalance.abs().toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceColumn(String title, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 5),
        Text(
          "₹ ${amount.toStringAsFixed(0)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _groupTile(String title, String subtitle) {
    Color statusColor = Colors.grey;

    if (subtitle.contains("owe")) {
      statusColor = Colors.redAccent;
    } else if (subtitle.contains("owed")) {
      statusColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: softPink.withOpacity(0.3),
            child: Icon(
              Icons.group,
              color: primaryPurple,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
