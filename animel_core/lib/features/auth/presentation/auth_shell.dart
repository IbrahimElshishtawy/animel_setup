// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const authPrimary = Color(0xFF4B1A45);
const authAccent = Color(0xFFE27D60);
const authInk = Color(0xFF2F1B2D);
const authMuted = Color(0xFF7A6876);

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.eyebrow,
    this.hero,
    this.footer,
    this.showBackButton = false,
    this.fallbackRoute,
  });

  final String? eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? hero;
  final Widget? footer;
  final bool showBackButton;
  final String? fallbackRoute;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 360 ? 16.0 : 20.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF6F1), Colors.white, Color(0xFFF5EAF4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const _Glow(
              alignment: Alignment.topRight,
              size: 240,
              color: Color(0x33E27D60),
            ),
            const _Glow(
              alignment: Alignment.bottomLeft,
              size: 280,
              color: Color(0x224B1A45),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    18,
                    horizontalPadding,
                    24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 470),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            18,
                            horizontalPadding,
                            22,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.84),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.72),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x144B1A45),
                                blurRadius: 30,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showBackButton) ...[
                                _BackPill(fallbackRoute: fallbackRoute),
                                const SizedBox(height: 20),
                              ],
                              if (eyebrow != null) ...[
                                AuthTag(label: eyebrow!),
                                const SizedBox(height: 18),
                              ],
                              if (hero != null) ...[
                                hero!,
                                const SizedBox(height: 24),
                              ],
                              Text(
                                title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: authInk,
                                      fontWeight: FontWeight.w800,
                                      height: 1.18,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: authMuted, height: 1.55),
                              ),
                              const SizedBox(height: 24),
                              child,
                              if (footer != null) ...[
                                const SizedBox(height: 22),
                                footer!,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
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

class AuthHeroPanel extends StatelessWidget {
  const AuthHeroPanel({super.key, required this.child, this.height = 170});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFF9E8E1), Color(0xFFF2E3F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12E27D60),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 6,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Center(child: child),
        ],
      ),
    );
  }
}

class AuthTag extends StatelessWidget {
  const AuthTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEEE8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 16, color: authAccent),
          Text(
            label,
            style: const TextStyle(
              color: authAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: authPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

class AuthGhostButton extends StatelessWidget {
  const AuthGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: authPrimary,
          side: const BorderSide(color: Color(0xFFE4D3E1)),
          backgroundColor: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [authPrimary, authAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(1),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFCEEE8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'G',
                    style: TextStyle(
                      color: authAccent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: authInk,
                    fontWeight: FontWeight.w700,
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

class AuthTextFieldBox extends StatelessWidget {
  const AuthTextFieldBox({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: authInk, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white.withOpacity(0.92),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE8DBE5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: authPrimary, width: 1.3),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthFooterPrompt extends StatelessWidget {
  const AuthFooterPrompt({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onTap,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(prompt, style: const TextStyle(color: authMuted)),
          TextButton(
            onPressed: onTap,
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: authPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.fallbackRoute});

  final String? fallbackRoute;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          if (context.canPop()) {
            context.pop();
            return;
          }
          if (fallbackRoute != null) {
            context.go(fallbackRoute!);
          }
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE8DBE5)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: authPrimary,
              ),
              SizedBox(width: 8),
              Text(
                'Back',
                style: TextStyle(
                  color: authPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.alignment,
    required this.size,
    required this.color,
  });

  final Alignment alignment;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
