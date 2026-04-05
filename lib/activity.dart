import 'package:flutter/material.dart';
import 'package:myapp/dummydata.dart';
import 'package:myapp/grpmodel.dart';


class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//
// class ActivityPage extends StatelessWidget {
//   const ActivityPage({Key? key}) : super(key: key);
//
//   final Color primaryPurple = const Color(0xFF982598);
//   final Color softPink = const Color(0xFFE491C9);
//   final Color lightBg = const Color(0xFFF7F2F8);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightBg,
//       appBar: AppBar(
//         title: const Text("Activity"),
//         backgroundColor: primaryPurple,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: activities.length,
//         itemBuilder: (context, index) {
//           final activity = activities[index];
//           return _activityCard(activity);
//         },
//       ),
//     );
//   }
//
//   Widget _activityCard(ActivityModel activity) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Main text
//           Text.rich(
//             TextSpan(
//               style: const TextStyle(fontSize: 14, color: Colors.black),
//               children: [
//                 TextSpan(
//                   text: "${activity.userName} ",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 TextSpan(text: _getActionText(activity)),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           // Group name
//           Row(
//             children: [
//               Icon(Icons.group, size: 16, color: primaryPurple),
//               const SizedBox(width: 6),
//               Text(
//                 "in ${activity.groupName}",
//                 style: TextStyle(
//                   color: primaryPurple,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 6),
//
//           Text(
//             _formatTime(activity.timestamp),
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getActionText(ActivityModel activity) {
//     if (activity.type == "expense") {
//       return "added ${activity.title} (₹${activity.amount?.toStringAsFixed(0)})";
//     } else if (activity.type == "settlement") {
//       return "settled ₹${activity.amount?.toStringAsFixed(0)}";
//     } else if (activity.type == "group") {
//       return "joined the group";
//     }
//     return "";
//   }
//
//   String _formatTime(DateTime time) {
//     final diff = DateTime.now().difference(time);
//
//     if (diff.inMinutes < 60) {
//       return "${diff.inMinutes} mins ago";
//     } else if (diff.inHours < 24) {
//       return "${diff.inHours} hrs ago";
//     } else {
//       return "${diff.inDays} days ago";
//     }
//   }
// }
