import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Title
            const Text(
              'Forgot your\nPassword?',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B5CE6),
                height: 1.2,
              ),
            ),

            const SizedBox(height: 60),

            // Email Input Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF5B5CE6), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Enter Email Address',
                  hintStyle: TextStyle(color: Colors.black38),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Send Button
            ElevatedButton(
              onPressed: () {
                // Handle password reset logic here
                print('Reset email sent to: ${_emailController.text}');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset email sent!'),
                    backgroundColor: Color(0xFF5B5CE6),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B5CE6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.send, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Send',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
