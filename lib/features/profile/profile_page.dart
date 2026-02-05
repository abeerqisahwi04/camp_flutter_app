import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_favorites_page.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/auth/auth_page.dart';
import 'package:flutter_application_1/features/profile/change_password_page.dart';
import 'package:flutter_application_1/features/profile/edit_profile_page.dart';
import 'package:flutter_application_1/features/profile/my_bookings_page.dart';
import 'package:flutter_application_1/features/profile/contact_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName ?? 'Camper User';
    final email = user?.email ?? 'No email';

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // صورة وبطاقة الاسم
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF15252A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: kAccent,
                    child: Icon(Icons.person, size: 38, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Edit Profile
            _ProfileItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),

            // Change Password
            _ProfileItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
            ),

            // My Orders
            _ProfileItem(
              icon: Icons.history,
              title: 'My Bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingsPage()),
                );
              },
            ),

            _ProfileItem(
              icon: Icons.favorite_border,
              title: 'My Favorites',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyFavoritesPage()),
                );
              },
            ),

            const SizedBox(height: 18),

            const Text(
              'More',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Help & Support → contact_page.dart
            _ProfileItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactPage()),
                );
              },
            ),

            // Log out
            _ProfileItem(
              icon: Icons.logout,
              title: 'Log out',
              danger: true,
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.redAccent : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF15252A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: danger ? Colors.redAccent : Colors.white70),
        title: Text(title, style: TextStyle(color: color)),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white38,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
