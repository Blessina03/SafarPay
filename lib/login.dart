import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final User? user = await _authService.login(email, password);

    if (user != null) {
      // ✅ LOGIN SUCCESS
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 65,
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Login Successful 🎉",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Welcome to Safar Pay!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      });

    } else {
      // ❌ INVALID CREDENTIALS
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 65,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Invalid Credentials ❌",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please check your email and password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E9E9),
      body: Center(
        child: Container(
          width: 340,
          padding:
          const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  "Split Smart. Travel Easy.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF15173D),
                  ),
                ),
                const SizedBox(height: 30),

                /// EMAIL FIELD
                TextFormField(
                  controller: emailController,
                  onChanged: (_) {
                    if (_autoValidateMode ==
                        AutovalidateMode.onUserInteraction) {
                      _formKey.currentState!.validate();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF982598),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1E9E9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _validateEmail,
                ),

                const SizedBox(height: 15),

                /// PASSWORD FIELD
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  onChanged: (_) {
                    if (_autoValidateMode ==
                        AutovalidateMode.onUserInteraction) {
                      _formKey.currentState!.validate();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF982598),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF982598),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1E9E9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _validatePassword,
                ),

                const SizedBox(height: 25),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF982598),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _login,
                    child: const Text(
                      "Log in",
                      style:
                      TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      color: Color(0xFF15173D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}