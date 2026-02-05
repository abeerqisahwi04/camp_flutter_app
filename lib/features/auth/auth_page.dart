import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_images.dart';
import 'package:flutter_application_1/features/auth/widgets/auth_text_field.dart';
import 'package:flutter_application_1/features/auth/forgot_password_page.dart';
import 'package:flutter_application_1/features/explore/explore_camps_page.dart';
import 'package:flutter_application_1/features/auth/service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Controllers
  final TextEditingController _loginEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();

  final TextEditingController _signupName = TextEditingController();
  final TextEditingController _signupEmail = TextEditingController();
  final TextEditingController _signupPassword = TextEditingController();

  // Firebase Auth service
  final AuthService _authService = AuthService();

  bool _isLoading = false;

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

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------------- LOGIN ----------------
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = _loginEmail.text.trim();
    final password = _loginPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please enter email and password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(email: email, password: password);
      _goToHome();
    } catch (e) {
      _showError("Login failed. Please check your email and password.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------- SIGN UP ----------------
  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    final name = _signupName.text.trim();
    final email = _signupEmail.text.trim();
    final password = _signupPassword.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Please fill all fields.");
      return;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(name: name, email: email, password: password);
      _goToHome();
    } on FirebaseAuthException catch (e) {
      print('🔥 [AuthPage._signUp] code: ${e.code}');
      print('🔥 [AuthPage._signUp] message: ${e.message}');
      _showError("Firebase error: ${e.code}");
    } catch (e) {
      print('🔥 [AuthPage._signUp] other error: $e');
      _showError("Sign up failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                // صورة الهيرو
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

                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: CircularProgressIndicator(color: kAccent),
                  ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: TabBarView(
                      children: [
                        // ---------------- LOGIN TAB ----------------
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
                                    FocusScope.of(context).unfocus();
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
                                  onPressed: _isLoading ? null : _login,
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

                        // ---------------- SIGN UP TAB ----------------
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
                                  onPressed: _isLoading ? null : _signUp,
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
