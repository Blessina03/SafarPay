class GroupModel {
  final String id;
  final String name;
  final List<String> members;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
  });
}

class ExpenseModel {
  final String id;
  final String title;        // Expense title
  final String category;     // Food, Travel, Other
  final String description;  // Used only if category = Other
  final double amount;
  final DateTime date;
  final String paidById;
  final String paidByName;
  final String paidByAvatar;
  final List<String> participants;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.paidById,
    required this.paidByName,
    required this.paidByAvatar,
    required this.participants,
  });
}
