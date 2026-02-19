import 'package:flutter/material.dart';
import 'dummydata.dart';
import 'grpmodel.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({Key? key}) : super(key: key);

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final Color primaryPurple = const Color(0xFF982598);
  final Color lightBg = const Color(0xFFF1E9E9);

  final String currentUserId = "you";

  String selectedCategory = "Food";
  String selectedSplit = "Equal";

  GroupModel? selectedGroup;
  String selectedEntity = "";

  bool splitAllMembers = true;
  bool showAdvanced = false;

  List<String> selectedMembers = [];
  DateTime selectedDate = DateTime.now();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<String> categories = [
    "Food",
    "Travel",
    "Rent",
    "Shopping",
    "Entertainment",
    "Other"
  ];

  @override
  void initState() {
    super.initState();

    if (groups.isNotEmpty) {
      selectedGroup = groups.first;
      selectedEntity = selectedGroup!.name;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        title: const Text(
          "Add Expense",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _inputField("Expense Title", "Dinner at restaurant",
                controller: titleController),

            const SizedBox(height: 20),

            _inputField("Amount", "₹ 0.00",
                controller: amountController,
                keyboardType: TextInputType.number),

            const SizedBox(height: 25),

            /// CATEGORY
            const Text("Category",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryPurple : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            /// DESCRIPTION IF OTHER
            if (selectedCategory == "Other") ...[
              const SizedBox(height: 20),
              _inputField("Description", "Add note",
                  controller: descriptionController),
            ],

            const SizedBox(height: 25),

            /// GROUP SELECTOR
            const Text("Split Between",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _openSelector,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedEntity),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SPLIT MEMBERS
            if (selectedGroup != null) ...[
              const Text("Split With",
                  style: TextStyle(fontWeight: FontWeight.w600)),

              RadioListTile(
                value: true,
                groupValue: splitAllMembers,
                title: const Text("All Members"),
                onChanged: (value) {
                  setState(() {
                    splitAllMembers = true;
                  });
                },
              ),

              RadioListTile(
                value: false,
                groupValue: splitAllMembers,
                title: const Text("Select Members"),
                onChanged: (value) {
                  setState(() {
                    splitAllMembers = false;
                  });
                },
              ),

              if (!splitAllMembers)
                Column(
                  children: selectedGroup!.members.map((member) {
                    return CheckboxListTile(
                      value: selectedMembers.contains(member),
                      title: Text(member),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedMembers.add(member);
                          } else {
                            selectedMembers.remove(member);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
            ],

            const SizedBox(height: 25),

            /// DATE
            const Text("Date",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
              ),
            ),

            const SizedBox(height: 35),

            /// SAVE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveExpense,
              child: const Text(
                "Save Expense",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    if (selectedGroup == null) return;

    if (titleController.text.isEmpty ||
        amountController.text.isEmpty) {
      return;
    }

    final double amount =
        double.tryParse(amountController.text) ?? 0;

    final newExpense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      category: selectedCategory,
      description:
      selectedCategory == "Other" ? descriptionController.text : "",
      amount: amount,
      date: selectedDate,
      paidById: currentUserId,
      paidByName: currentUserId,
      paidByAvatar: "",
      participants: splitAllMembers
          ? selectedGroup!.members
          : selectedMembers,
    );

    groupExpenses[selectedGroup!.id]?.add(newExpense);

    Navigator.pop(context);
  }

  void _openSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Text("Groups",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...groups.map((group) => ListTile(
                leading: const Icon(Icons.group),
                title: Text(group.name),
                onTap: () {
                  setState(() {
                    selectedGroup = group;
                    selectedEntity = group.name;
                    selectedMembers.clear();
                    splitAllMembers = true;
                  });
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _inputField(String label, String hint,
      {required TextEditingController controller,
        TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
