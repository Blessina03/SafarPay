import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryPurple = const Color(0xFF982598);
  final Color lightBg = const Color(0xFFF7F2F8);

  String userName = "User Name";
  String email = "user@email.com";
  String currency = "₹ INR";
  String language = "English";

  bool notificationsEnabled = true;
  bool darkMode = false;

  int joinedGroups = 3;
  double totalExpenses = 8450.0;
  double youOwe = 1250.0;
  double oweToYou = 2300.0;
  double rating = 4.0;

  File? _profileImage;

  // ================= EDIT NAME =================
  void _editName() {
    final controller = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Enter Name"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
            ),
            onPressed: () {
              setState(() => userName = controller.text);
              Navigator.pop(context);
            },
            child: const Text("Update",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= EDIT RATING =================
  void _editRating() {
    double tempRating = rating;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rate Safar Pay"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < tempRating
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  rating = index + 1.0;
                });
                Navigator.pop(context);
              },
            );
          }),
        ),
      ),
    );
  }

  // ================= IMAGE PICKER =================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
    await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  // ================= DROPDOWN =================
  void _showSelector(
      String title,
      List<String> options,
      String selectedValue,
      Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primaryPurple)),
            const SizedBox(height: 15),
            ...options.map(
                  (e) => ListTile(
                title: Text(e),
                trailing: e == selectedValue
                    ? Icon(Icons.check,
                    color: primaryPurple)
                    : null,
                onTap: () {
                  onSelect(e);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= PROFILE HEADER =================
            _profileHeader(),

            const SizedBox(height: 25),

            // ================= SUMMARY CARD =================
            _summaryCard(),

            const SizedBox(height: 25),

            _sectionTitle("Account Settings"),
            _settingsCard([
              _tile(Icons.lock, "Change Password"),
              _tile(Icons.attach_money, "Currency",
                  subtitle: currency, onTap: () {
                    _showSelector("Select Currency",
                        ["₹ INR", "\$ USD", "€ EUR"],
                        currency,
                            (val) => setState(() => currency = val));
                  }),
              _tile(Icons.language, "Language",
                  subtitle: language, onTap: () {
                    _showSelector("Select Language",
                        ["English", "Hindi", "Spanish"],
                        language,
                            (val) => setState(() => language = val));
                  }),
            ]),

            const SizedBox(height: 25),

            _sectionTitle("Preferences"),
            _settingsCard([
              SwitchListTile(
                title: const Text("Push Notifications"),
                value: notificationsEnabled,
                activeColor: primaryPurple,
                onChanged: (val) =>
                    setState(() => notificationsEnabled = val),
              ),
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: darkMode,
                activeColor: primaryPurple,
                onChanged: (val) =>
                    setState(() => darkMode = val),
              ),
            ]),

            const SizedBox(height: 25),

            _sectionTitle("Support"),
            _settingsCard([
              ListTile(
                leading:
                const Icon(Icons.star, color: Colors.amber),
                title: const Text("Rate Safar Pay"),
                subtitle: Text("$rating ★"),
                onTap: _editRating,
              ),
              _tile(Icons.mail_outline, "Contact Us",
                  subtitle: "support@safarpay.com"),
              _tile(Icons.help_outline, "Help & FAQs"),
              _tile(Icons.info_outline, "About Safar Pay"),
            ]),

            const SizedBox(height: 30),

            Center(
              child: TextButton(
                onPressed: () {},
                child: Text("Logout",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryPurple)),
              ),
            ),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text("Delete Account",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red)),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text("Safar Pay v1.0.0",
                  style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const NetworkImage(
                    "https://i.pravatar.cc/150?img=5")
                as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    GestureDetector(
                      onTap: _editName,
                      child: Icon(Icons.edit,
                          size: 18,
                          color: primaryPurple),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(email,
                    style: const TextStyle(
                        color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text("Your Summary",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _statItem("Groups",
                  joinedGroups.toString()),
              _statItem("Total Spent",
                  "₹$totalExpenses"),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _statItem("You Owe",
                  "₹$youOwe",
                  valueColor: Colors.red),
              _statItem("Owe To You",
                  "₹$oweToYou",
                  valueColor: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(children: children),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryPurple)),
    );
  }

  Widget _tile(IconData icon, String title,
      {String? subtitle, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: primaryPurple),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  Widget _statItem(String title, String value,
      {Color? valueColor}) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: valueColor ?? primaryPurple)),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius:
      BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
        )
      ],
    );
  }
}