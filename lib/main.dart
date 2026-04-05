import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/first.dart';
import 'package:myapp/login.dart';
import 'package:myapp/signup.dart';
import 'package:myapp/home.dart';
import 'package:myapp/addexpense.dart';
import 'package:myapp/creategrp.dart';
import 'package:myapp/groups.dart';
import 'package:myapp/mainscreen.dart';
import 'package:myapp/joingrp.dart';
import 'package:myapp/viewgrp.dart';
import 'package:myapp/activity.dart';
import "package:myapp/profile.dart";



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(SafarPayApp());
}

class SafarPayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SAFAR Pay",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => MainScreen(),
        '/addexpense': (context) => AddExpensePage(),
        '/creategrp': (context) => CreateGroupPage(),
        '/groups': (context) => GroupsPage(),
        '/joingrp': (context) => JoinGroupPage(),
        '/viewgrp': (context) => ViewGroupsPage(),
        '/activity': (context) => ActivityPage(),
        '/profile': (context) => ProfilePage(),
         },
      );
  }
}