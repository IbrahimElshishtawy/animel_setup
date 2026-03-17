// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _onLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go('/home');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      showBackButton: true,
      fallbackRoute: '/welcome-auth',
      eyebrow: 'Sign in',
      title: 'Welcome back.',
      subtitle:
          'Continue helping animals, checking rescue activity, and staying connected to your community.',
      hero: AuthHeroPanel(
        height: 154,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 280;

            return Row(
              children: [
                Container(
                  width: compact ? 66 : 76,
                  height: compact ? 66 : 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Image(
                    image: AssetImage('assets/image/image.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safe access',
                        style: TextStyle(
                          color: authPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'A softer sign-in flow for your daily animal care work.',
                        style: TextStyle(color: authMuted, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      footer: AuthFooterPrompt(
        prompt: 'Don\'t have an account?',
        actionLabel: 'Create one',
        onTap: () => context.go('/register'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTextFieldBox(
            label: 'Email',
            controller: _emailController,
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline_rounded),
          ),
          const SizedBox(height: 16),
          AuthTextFieldBox(
            label: 'Password',
            controller: _passwordController,
            hint: 'Your password',
            obscureText: _obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: authPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          AuthPrimaryButton(
            label: 'Login',
            onPressed: _onLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 12),
          AuthSocialButton(label: 'Continue with Google', onTap: () {}),
        ],
      ),
    );
  }
}
