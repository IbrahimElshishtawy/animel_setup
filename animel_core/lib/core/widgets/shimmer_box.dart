// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  final double height;
  final double? width;
  final BorderRadius borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerX = (_controller.value * 2) - 1;

        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1 + shimmerX, -0.25),
                end: Alignment(1 + shimmerX, 0.25),
                colors: [
                  scheme.surfaceContainerHighest.withOpacity(0.82),
                  scheme.surface.withOpacity(0.98),
                  scheme.surfaceContainerHighest.withOpacity(0.82),
                ],
                stops: const [0.1, 0.5, 0.9],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          ),
        );
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        color: scheme.surfaceContainerHighest,
      ),
    );
  }
}
