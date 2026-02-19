import 'package:flutter/material.dart';
import 'dummydata.dart';
import 'grpmodel.dart';
import 'settlement.dart';

class ViewGroupsPage extends StatefulWidget {
  const ViewGroupsPage({Key? key}) : super(key: key);

  @override
  State<ViewGroupsPage> createState() => _ViewGroupsPageState();
}

class _ViewGroupsPageState extends State<ViewGroupsPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF982598);
    final Color softPink = const Color(0xFFE491C9);
    final Color lightBg = const Color(0xFFF1E9E9);

    // Filter groups from dummyGroups using search
    final filteredGroups = groups
        .where((g) => g.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: const Text(
          "Your Groups",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔍 Search Bar
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search groups...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 📋 Groups List or Empty State
              filteredGroups.isEmpty
                  ? _emptyState(primaryPurple, softPink)
                  : Expanded(
                child: ListView.builder(
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {
                    final group = filteredGroups[index];
                    return _groupCard(group, primaryPurple, softPink);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Group Card Widget
  Widget _groupCard(GroupModel group, Color primaryPurple, Color softPink) {
    return _AnimatedPressable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettlementPage(group: group),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: softPink.withOpacity(0.3),
              child: Icon(Icons.group, color: primaryPurple),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${group.members} members",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 🔹 Empty State
  Widget _emptyState(Color primaryPurple, Color softPink) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: softPink.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  size: 65,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "No Groups Yet",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Start splitting expenses with your friends.\nCreate your first group now!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 180, // shorter width button
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/creategrp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Group",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✨ Animated Pressable Widget
class _AnimatedPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedPressable({required this.child, required this.onTap});

  @override
  State<_AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<_AnimatedPressable> {
  double scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => scale = 0.96);
  void _onTapUp(TapUpDetails details) => setState(() => scale = 1.0);
  void _onTapCancel() => setState(() => scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
