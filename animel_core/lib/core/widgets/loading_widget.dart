// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key, this.message, this.itemCount = 3});

  final String? message;
  final int itemCount;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shimmerX = (_controller.value * 2) - 1;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary.withOpacity(0.14),
                          scheme.secondary.withOpacity(0.16),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          scheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.message != null) ...[
                    Text(
                      widget.message!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  ...List.generate(
                    widget.itemCount,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment(-1 + shimmerX, -0.2),
                              end: Alignment(1 + shimmerX, 0.2),
                              colors: [
                                scheme.surfaceContainerHighest.withOpacity(0.8),
                                scheme.surface.withOpacity(0.95),
                                scheme.surfaceContainerHighest.withOpacity(0.8),
                              ],
                              stops: const [0.2, 0.5, 0.8],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Container(
                            height: 86,
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
