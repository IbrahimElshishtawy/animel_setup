import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.md)),
    this.blurSigma = 18,
    this.gradientColors,
    this.borderColor,
    this.shadowColor,
    this.shadowOpacity,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final double blurSigma;
  final List<Color>? gradientColors;
  final Color? borderColor;
  final Color? shadowColor;
  final double? shadowOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final colors =
        gradientColors ??
        [
          Colors.white.withValues(alpha: isDark ? 0.12 : 0.74),
          Colors.white.withValues(alpha: isDark ? 0.06 : 0.34),
        ];

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: AppShadows.layered(
          shadowColor ?? scheme.primary,
          opacity: shadowOpacity ?? (isDark ? 0.14 : 0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color:
                    borderColor ??
                    scheme.outlineVariant.withValues(
                      alpha: isDark ? 0.34 : 0.72,
                    ),
              ),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

class ScaleTap extends StatefulWidget {
  const ScaleTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.97,
    this.duration = AppMotion.fast,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? widget.scaleDown : 1,
        duration: widget.duration,
        curve: AppMotion.emphasized,
        child: widget.child,
      ),
    );
  }
}
