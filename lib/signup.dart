import 'package:flutter/material.dart';
import 'home.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/firestore_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // 🔥 FIREBASE SIGNUP
  Future<void> _signup() async {
    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      print("Signup button pressed");

      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        print("Fields are empty");
        return;
      }

      // 1️⃣ Firebase Auth signup
      final user = await _authService.signUp(email, password);

      if (user != null) {
        print("Signup success: ${user.uid}");

        // 2️⃣ Save user to Firestore
        await _firestoreService.saveUser(name, email);

        print("User saved to Firestore");

        // 3️⃣ Navigate to Home screen
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      print("Signup failed: $e");
    }
  }

  // ---------------- VALIDATORS ----------------

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Enter valid email (example@gmail.com)";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    final passwordRegex =
    RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$');

    if (!passwordRegex.hasMatch(value)) {
      return "Min 6 chars, 1 number & 1 symbol required";
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required";
    }

    if (value != passwordController.text) {
      return "Passwords do not match";
    }

    return null;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E9E9),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 340,
            padding: const EdgeInsets.symmetric(
                vertical: 40, horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                children: [
                  const Text(
                    "SAFAR- पे",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15173D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// NAME
                  TextFormField(
                    controller: nameController,
                    onChanged: (_) {
                      if (_autoValidateMode ==
                          AutovalidateMode.onUserInteraction) {
                        _formKey.currentState!.validate();
                      }
                    },
                    decoration:
                    _inputDecoration("Full Name",
                        Icons.person_outline),
                    validator: _validateName,
                  ),

                  const SizedBox(height: 15),

                  /// EMAIL
                  TextFormField(
                    controller: emailController,
                    onChanged: (_) {
                      if (_autoValidateMode ==
                          AutovalidateMode.onUserInteraction) {
                        _formKey.currentState!.validate();
                      }
                    },
                    decoration: _inputDecoration(
                        "Email", Icons.email_outlined),
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 15),

                  /// PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: (_) {
                      if (_autoValidateMode ==
                          AutovalidateMode.onUserInteraction) {
                        _formKey.currentState!.validate();
                      }
                    },
                    decoration: _passwordDecoration(
                      "Password",
                      _isPasswordVisible,
                          () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: _validatePassword,
                  ),

                  const SizedBox(height: 15),

                  /// CONFIRM PASSWORD
                  TextFormField(
                    controller:
                    confirmPasswordController,
                    obscureText:
                    !_isConfirmPasswordVisible,
                    onChanged: (_) {
                      if (_autoValidateMode ==
                          AutovalidateMode.onUserInteraction) {
                        _formKey.currentState!.validate();
                      }
                    },
                    decoration: _passwordDecoration(
                      "Confirm Password",
                      _isConfirmPasswordVisible,
                          () {
                        setState(() {
                          _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    validator:
                    _validateConfirmPassword,
                  ),

                  const SizedBox(height: 25),

                  /// SIGNUP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF982598),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              30),
                        ),
                      ),
                      onPressed: _signup,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- DECORATION ----------------

  InputDecoration _inputDecoration(
      String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon:
      Icon(icon, color: const Color(0xFF982598)),
      filled: true,
      fillColor: const Color(0xFFF1E9E9),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration _passwordDecoration(
      String hint,
      bool visible,
      VoidCallback toggle) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF982598)),
      suffixIcon: IconButton(
        icon: Icon(
          visible
              ? Icons.visibility
              : Icons.visibility_off,
          color: const Color(0xFF982598),
        ),
        onPressed: toggle,
      ),
      filled: true,
      fillColor: const Color(0xFFF1E9E9),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
}