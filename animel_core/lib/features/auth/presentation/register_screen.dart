// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasPet = false;

  Future<void> _onRegister() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go('/verify-email');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      showBackButton: true,
      fallbackRoute: '/welcome-auth',
      eyebrow: 'Create account',
      title: 'Join HopePaw with a calm, modern setup.',
      subtitle:
          'Create your profile in a few simple steps and start supporting rescue, adoption, and daily care.',
      hero: const AuthHeroPanel(height: 158, child: _RegisterHero()),
      footer: AuthFooterPrompt(
        prompt: 'Already have an account?',
        actionLabel: 'Login',
        onTap: () => context.go('/login'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 380;

              if (stacked) {
                return Column(
                  children: [
                    AuthTextFieldBox(
                      label: 'First name',
                      controller: _firstName,
                      hint: 'Your first name',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    const SizedBox(height: 16),
                    AuthTextFieldBox(
                      label: 'Last name',
                      controller: _lastName,
                      hint: 'Your last name',
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: AuthTextFieldBox(
                      label: 'First name',
                      controller: _firstName,
                      hint: 'Your first name',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuthTextFieldBox(
                      label: 'Last name',
                      controller: _lastName,
                      hint: 'Your last name',
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          AuthTextFieldBox(
            label: 'Email',
            controller: _email,
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline_rounded),
          ),
          const SizedBox(height: 16),
          AuthTextFieldBox(
            label: 'Password',
            controller: _password,
            hint: 'At least 8 characters',
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
          const SizedBox(height: 20),
          const Text(
            'Do you already have a pet?',
            style: TextStyle(color: authInk, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ChoiceCard(
                  label: 'Yes, I do',
                  subtitle: 'Customize my care journey.',
                  isSelected: _hasPet,
                  onTap: () => setState(() => _hasPet = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ChoiceCard(
                  label: 'Not yet',
                  subtitle: 'I am here to help and explore.',
                  isSelected: !_hasPet,
                  onTap: () => setState(() => _hasPet = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: 'Create account',
            onPressed: _onRegister,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}

class _RegisterHero extends StatelessWidget {
  const _RegisterHero();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 74,
          height: 74,
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
                'Gentle onboarding',
                style: TextStyle(
                  color: authPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Set up your profile and shape a more personal pet-care experience.',
                style: TextStyle(color: authMuted, height: 1.45),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF9EEF4) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? authPrimary : const Color(0xFFE8DBE5),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: authInk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isSelected ? authPrimary : const Color(0xFFCDB8C8),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  color: authMuted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
