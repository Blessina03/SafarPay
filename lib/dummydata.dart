import 'grpmodel.dart';

const String currentUserId = "You";

final List<GroupModel> groups = [
  GroupModel(
    id: "g1",
    name: "Trip to Goa",
    members: ["You", "Alice", "John", "Rahul"],
  ),
  GroupModel(
    id: "g2",
    name: "Flatmates",
    members: ["You", "Alice", "Rahul"],
  ),
];

final List<String> friends = [
  "Alice",
  "John",
  "Rahul",
];

final Map<String, List<ExpenseModel>> groupExpenses = {
  "g1": [
    ExpenseModel(
      id: "e1",
      title: "Lunch at Beach Shack",
      category: "Food",
      description: "",
      amount: 2000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      paidById: "Alice",
      paidByName: "Alice",
      paidByAvatar: "",
      participants: ["You", "Alice", "John", "Rahul"],
    ),
    ExpenseModel(
      id: "e2",
      title: "Scooter Rent",
      category: "Travel",
      description: "",
      amount: 4000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      paidById: "You",
      paidByName: "You",
      paidByAvatar: "",
      participants: ["You", "Alice", "John", "Rahul"],
    ),
    ExpenseModel(
      id: "e3",
      title: "Local Guide",
      category: "Other",
      description: "Beach tour guide charges",
      amount: 1500,
      date: DateTime.now(),
      paidById: "You",
      paidByName: "You",
      paidByAvatar: "",
      participants: ["You", "Alice"],
    ),
  ],
};
