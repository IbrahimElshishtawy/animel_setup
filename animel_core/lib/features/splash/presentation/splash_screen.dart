// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _glowFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );

    _cardScale = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _glowFade = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        context.go('/choose-language');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withOpacity(0.22),
                  theme.scaffoldBackgroundColor,
                  scheme.secondary.withOpacity(0.16),
                ],
              ),
            ),
          ),

          Positioned(
            top: -70,
            left: -40,
            child: _BlurCircle(
              size: 200,
              color: scheme.primary.withOpacity(0.16),
            ),
          ),

          Positioned(
            bottom: -80,
            right: -30,
            child: _BlurCircle(
              size: 220,
              color: scheme.secondary.withOpacity(0.14),
            ),
          ),

          Positioned(
            top: 140,
            right: 30,
            child: _BlurCircle(
              size: 100,
              color: scheme.tertiary.withOpacity(0.10),
            ),
          ),

          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _cardFade,
                child: ScaleTransition(
                  scale: _cardScale,
                  child: AnimatedBuilder(
                    animation: _glowFade,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: 310,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 30,
                              ),
                              decoration: BoxDecoration(
                                color: theme.cardColor.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: scheme.primary.withOpacity(
                                      0.10 * _glowFade.value,
                                    ),
                                    blurRadius: 30,
                                    offset: const Offset(0, 16),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.primary.withOpacity(0.08),
                            border: Border.all(
                              color: scheme.primary.withOpacity(0.14),
                            ),
                          ),
                          child: const AppMedia(height: 90, width: 90),
                        ),
                        const SizedBox(height: 22),
                        SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              Text(
                                'Animal Connect',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Premium animal care, discovery, rescue, and adoption.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              scheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
