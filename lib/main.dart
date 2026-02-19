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

void main() {
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
         },
      );
  }
}