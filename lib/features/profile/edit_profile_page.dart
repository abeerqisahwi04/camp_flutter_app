import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');

    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first.')));
      return;
    }

    setState(() => _saving = true);

    try {
      final newName = _nameController.text.trim();

      if (newName.isNotEmpty && newName != user.displayName) {
        await user.updateDisplayName(newName);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated ✅')));

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to update profile.')),
      );
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: kAccent,
                    child: Icon(Icons.person, size: 42, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Change photo"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Full Name",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            _darkField(hint: "Camper User", controller: _nameController),

            const SizedBox(height: 16),

            //
            const Text(
              "Email",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            _darkField(
              hint: "camper@example.com",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
            ),

            const SizedBox(height: 16),

            //
            const Text(
              "Phone",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            _darkField(
              hint: "+962 7X XXX XXXX",
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Save changes",
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
}

//
Widget _darkField({
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  bool enabled = true,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    enabled: enabled,
    readOnly: !enabled,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF15252A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}
