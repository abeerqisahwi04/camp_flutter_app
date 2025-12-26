import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    // مبدئياً (UI فقط) - لاحقاً بنربطه مع Firebase/Auth API
    setState(() => _sent = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reset link sent (demo). Check your email."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reset your password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your email and we’ll send you a reset link.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 18),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.email_outlined, color: kAccent),
                filled: true,
                fillColor: const Color(0xFF15252A),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: kAccent, width: 1.3),
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _sendResetLink,
                child: const Text(
                  "Send reset link",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _sent
                  ? Container(
                      key: const ValueKey("sent"),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15252A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: kAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "We sent a reset link (demo). You can go back and login.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
