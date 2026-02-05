import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool hideCurrent = true;
  bool hideNew = true;
  bool hideConfirm = true;

  bool _loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Current Password"),
            _passwordField(
              controller: currentController,
              hidden: hideCurrent,
              onToggle: () => setState(() => hideCurrent = !hideCurrent),
            ),

            const SizedBox(height: 16),

            _label("New Password"),
            _passwordField(
              controller: newController,
              hidden: hideNew,
              onToggle: () => setState(() => hideNew = !hideNew),
            ),

            const SizedBox(height: 16),

            _label("Confirm New Password"),
            _passwordField(
              controller: confirmController,
              hidden: hideConfirm,
              onToggle: () => setState(() => hideConfirm = !hideConfirm),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                        ),
                      )
                    : const Text(
                        "Update password",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 13),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: hidden,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF15252A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hidden ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    final currentPass = currentController.text.trim();
    final newPass = newController.text.trim();
    final confirmPass = confirmController.text.trim();

    if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showSnackBar('Please fill in all fields', isError: true);
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar(
        'New password must be at least 6 characters',
        isError: true,
      );
      return;
    }

    if (newPass != confirmPass) {
      _showSnackBar(
        'New password and confirmation do not match',
        isError: true,
      );
      return;
    }

    final user = _auth.currentUser;

    if (user == null || user.email == null) {
      _showSnackBar(
        'No logged-in user found. Please log in again.',
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPass,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPass);

      _showSnackBar('Password updated successfully 🎉');

      currentController.clear();
      newController.clear();
      confirmController.clear();
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';

      if (e.code == 'wrong-password') {
        message = 'Current password is incorrect';
      } else if (e.code == 'weak-password') {
        message = 'The new password is too weak';
      } else if (e.code == 'requires-recent-login') {
        message = 'Please log in again and try changing the password';
      }

      _showSnackBar(message, isError: true);
    } catch (e) {
      _showSnackBar('Unexpected error, please try again later', isError: true);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }
}
