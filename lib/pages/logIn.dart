import 'package:cecgrid/pages/faculty.dart';
import 'package:cecgrid/pages/forgot.dart';
import 'package:cecgrid/pages/student.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs; // Rx variable for GetX state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              "WELCOME",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B5CE6),
              ),
            ),
            const Text(
              "BACK",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B5CE6),
              ),
            ),
            const SizedBox(height: 50),

            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B5CE6),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF5B5CE6), width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'cecgrid@ceconline.edu',
                  hintStyle: TextStyle(color: Color.fromARGB(50, 0, 0, 0),fontWeight: FontWeight.w100),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B5CE6),
              ),
            ),
            const SizedBox(height: 8),

            Obx(() => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF5B5CE6), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword.value,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'cecgrid@123',
                      hintStyle: const TextStyle(color: Color.fromARGB(50, 0, 0, 0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black38,
                        ),
                        onPressed: () {
                          _obscurePassword.toggle(); // using GetX
                        },
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => ForgotPage(),transition: Transition.fade, duration: Duration(milliseconds: 500)); // Using GetX for navigation
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 16, color: Color(0xFF5B5CE6)),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                if (email.isNotEmpty) {
                  _emailController.clear();
                  if (email.contains("@fac")) {
                    Get.to(() => FacultyPage(),transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
                  } else {
                    Get.to(() => StudentPage(),transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                
                backgroundColor: const Color(0xFF5B5CE6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPage(),transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
                  },
                  child: const Text(
                    'Sign up now',
                    style: TextStyle(fontSize: 16, color: Color(0xFF5B5CE6)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
