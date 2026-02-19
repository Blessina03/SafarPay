import 'dart:math';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {

  final Color primaryPurple = const Color(0xFF982598);
  final Color softPink = const Color(0xFFE491C9);
  final Color lightBg = const Color(0xFFF1E9E9);

  final TextEditingController _groupNameController = TextEditingController();

  String groupId = "";
  List<String> selectedMembers = [];

  final List<Map<String, String>> friends = List.generate(
    8,
        (index) => {
      "name": "Friend ${index + 1}",
      "avatar": "https://i.pravatar.cc/150?img=${index + 20}"
    },
  );

  @override
  void initState() {
    super.initState();
    groupId = _generateGroupId();
  }

  String _generateGroupId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
            (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  void _toggleMember(String name) {
    setState(() {
      if (selectedMembers.contains(name)) {
        selectedMembers.remove(name);
      } else {
        selectedMembers.add(name);
      }
    });
  }

  void _createGroup() {
    if (_groupNameController.text.isEmpty || selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter group name and select members")),
      );
      return;
    }

    Navigator.pop(context); // For now just go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text("Create Group"),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            const SizedBox(height: 10),

            // 🖼 Group Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: softPink.withOpacity(0.3),
                    child: Icon(Icons.group,
                        size: 40,
                        color: primaryPurple),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: primaryPurple,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📝 Group Name
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: "Group Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🆔 Group ID
            Text(
              "Group ID: $groupId",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // 👥 Add Members
            const Text(
              "Add Members",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...friends.map((friend) {
              final isSelected =
              selectedMembers.contains(friend["name"]);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    NetworkImage(friend["avatar"]!),
                  ),
                  title: Text(friend["name"]!),
                  trailing: Checkbox(
                    value: isSelected,
                    activeColor: primaryPurple,
                    onChanged: (_) =>
                        _toggleMember(friend["name"]!),
                  ),
                  onTap: () =>
                      _toggleMember(friend["name"]!),
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            // 🚀 Create Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _createGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Create Group",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
