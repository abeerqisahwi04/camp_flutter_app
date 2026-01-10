import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_images.dart';
import 'package:flutter_application_1/features/auth/widgets/auth_text_field.dart';
import 'package:flutter_application_1/features/auth/forgot_password_page.dart';
import 'package:flutter_application_1/features/explore/explore_camps_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _loginEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();

  final TextEditingController _signupName = TextEditingController();
  final TextEditingController _signupEmail = TextEditingController();
  final TextEditingController _signupPassword = TextEditingController();

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _signupName.dispose();
    _signupEmail.dispose();
    _signupPassword.dispose();
    super.dispose();
  }

  void _goToHome() {
    FocusScope.of(context).unfocus();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ExploreCampsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: kBgDark,
          appBar: AppBar(
            backgroundColor: kBgDark,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus(); //
                Navigator.pop(context);
              },
            ),
            title: const Text(
              "Welcome to GoCamp",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: kAccent,
              labelColor: kAccent,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(text: "Login"),
                Tab(text: "Sign Up"),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(kHeroImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: TabBarView(
                      children: [
                        // LOGIN
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome back, camper 👋",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Login to continue your adventure.",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 24),

                              AuthTextField(
                                label: "Email",
                                icon: Icons.email_outlined,
                                controller: _loginEmail,
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                label: "Password",
                                icon: Icons.lock_outline,
                                controller: _loginPassword,
                                obscure: true,
                              ),

                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus(); //
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot password?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kAccent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: _goToHome, //
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //  SIGN UP
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Create your account 🌲",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Join GoCamp and start exploring.",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 24),

                              AuthTextField(
                                label: "Full Name",
                                icon: Icons.person_outline,
                                controller: _signupName,
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                label: "Email",
                                icon: Icons.email_outlined,
                                controller: _signupEmail,
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                label: "Password",
                                icon: Icons.lock_outline,
                                controller: _signupPassword,
                                obscure: true,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kAccent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: _goToHome, //
                                  child: const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
