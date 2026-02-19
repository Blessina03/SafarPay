import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'package:myapp/signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E9E9), // light background
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              const Text(
                "SAFAR- पे",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF15173D), // dark navy
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Split Smart. Travel Easy.",
                style: TextStyle(
                  color: Color(0xFF15173D),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),

              /// Illustration Placeholder
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE491C9), // soft pink
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.flight_takeoff, // travel vibe
                    size: 80,
                    color: Color(0xFF15173D),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF982598), // purple
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF982598),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Color(0xFF982598)),
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
