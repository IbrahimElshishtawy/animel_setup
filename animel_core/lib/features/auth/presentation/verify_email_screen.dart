// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'auth_shell.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  Future<void> _onVerify() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go('/home');
  }

  void _handleCodeChange(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      showBackButton: true,
      fallbackRoute: '/register',
      eyebrow: 'Email verification',
      title: 'Check your inbox for the 6-digit code.',
      subtitle:
          'We sent a verification code to your email address. Enter it below to finish setting up your account.',
      hero: const AuthHeroPanel(height: 150, child: _VerifyHero()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = constraints.maxWidth < 360 ? 44.0 : 48.0;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: fieldWidth,
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _handleCodeChange(index, value),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE8DBE5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: authPrimary,
                            width: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: 'Verify email',
            onPressed: _onVerify,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Resend code',
                style: TextStyle(
                  color: authPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyHero extends StatelessWidget {
  const _VerifyHero();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.72),
            borderRadius: BorderRadius.circular(22),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: authPrimary,
            size: 34,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Securely confirm your account and unlock the full HopePaw experience.',
            style: TextStyle(
              color: authMuted,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
