import 'package:flutter/material.dart';
import 'dummydata.dart';
import 'grpmodel.dart';
import 'settlement.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF982598);
    final Color softPink = const Color(0xFFE491C9);
    final Color lightBg = const Color(0xFFF1E9E9);

    // Filter groups from dummy data
    final filteredGroups = groups
        .where((g) => g.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔥 Top Action Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionCard(
                    "Create",
                    primaryPurple,
                    Icons.add,
                        () => Navigator.pushNamed(context, '/creategrp'),
                  ),
                  _actionCard(
                    "Join",
                    softPink,
                    Icons.group_add,
                        () => Navigator.pushNamed(context, '/joingrp'),
                  ),
                  _actionCard(
                    "View",
                    Colors.white,
                    Icons.remove_red_eye,
                        () => Navigator.pushNamed(context, '/viewgrp'),
                    textColor: primaryPurple,
                    border: Border.all(color: primaryPurple, width: 2),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔍 Search Bar
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search groups...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 📋 Groups List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {
                    final group = filteredGroups[index];
                    return _groupCard(group);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Animated Action Card Widget
  Widget _actionCard(
      String label,
      Color bgColor,
      IconData icon,
      VoidCallback onTap, {
        Color textColor = Colors.white,
        Border? border,
      }) {
    final bool isWhiteCard = bgColor == Colors.white;
    return Expanded(
      child: _AnimatedPressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: border,
            boxShadow: [
              BoxShadow(
                color: isWhiteCard ? Colors.black.withOpacity(0.08) : bgColor.withOpacity(0.35),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📋 Group Card Widget
  Widget _groupCard(GroupModel group) {
    final Color primaryPurple = const Color(0xFF982598);
    final Color softPink = const Color(0xFFE491C9);

    return _AnimatedPressable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SettlementPage(group: group)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${group.members.length} members",
                    style: TextStyle(color: Colors.grey.shade600),
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
}

/// ✨ Custom Animated Press Widget
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
