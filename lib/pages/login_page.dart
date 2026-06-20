import 'package:flutter/material.dart';
import 'package:genbi/components/glass.dart';
import 'package:genbi/components/primary_button.dart';
import 'package:genbi/components/secondary_button.dart';
import 'package:genbi/components/tab_switcher.dart';
import 'package:genbi/components/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _selectedTab = 0; // 0 = Login, 1 = Sign Up
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  stops: [0.1, 0.9],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "GenInsight",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 45,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Intelligent Data Transformations",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Colors.purple.shade50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Experience the next generation of operational intelligence.\nLeverage AI to perform business analytics and interactive\ndashboards in minutes without needing expertise.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassBox(
                      radius: 12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "TRUSTED BY EXPERTS",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
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
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabSwitcher(
                    selectedIndex: _selectedTab,
                    onChanged: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: _selectedTab == 0
                        ? _buildLoginForm(key: const ValueKey('login'))
                        : _buildSignUpForm(key: const ValueKey('signup')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Please enter your details to access your workspace.",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        const AuthTextField(label: "Email Address", hint: "name@company.com"),
        const SizedBox(height: 14),
        AuthTextField(
          label: "Password",
          hint: "••••••••",
          obscureText: _obscurePassword,
          labelTrailing: Text(
            "Forgot Password?",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF6A11CB),
            ),
          ),
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Remember me for 30 days",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(text: "Sign In", onTap: () {}),
        ),
        const SizedBox(height: 18),
        _buildDivider(),
        const SizedBox(height: 18),
        _buildSocialRow(),
        const SizedBox(height: 18),
        _buildTermsText(),
      ],
    );
  }

  Widget _buildSignUpForm({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create Account",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Let's get you set up with a new workspace.",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        const AuthTextField(label: "Full Name", hint: "John Doe"),
        const SizedBox(height: 14),
        const AuthTextField(label: "Email Address", hint: "name@company.com"),
        const SizedBox(height: 14),
        AuthTextField(
          label: "Password",
          hint: "••••••••",
          obscureText: _obscurePassword,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: "Confirm Password",
          hint: "••••••••",
          obscureText: _obscureConfirmPassword,
          suffix: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "I agree to the Terms of Service and Privacy Policy",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(text: "Create Account", onTap: () {}),
        ),
        const SizedBox(height: 18),
        _buildDivider(),
        const SizedBox(height: 18),
        _buildSocialRow(),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR CONTINUE WITH",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            text: "Google",
            icon: const Icon(Icons.g_mobiledata, size: 22, color: Colors.red),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SecondaryButton(
            text: "GitHub",
            icon: const Icon(Icons.code, size: 18, color: Colors.black87),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        children: const [
          TextSpan(text: "By continuing, you agree to our "),
          TextSpan(
            text: "Terms of Service",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.black87,
            ),
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.black87,
            ),
          ),
          TextSpan(text: "."),
        ],
      ),
    );
  }
}
