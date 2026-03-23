// ignore_for_file: deprecated_member_use

part of '../presentation/splash_screen.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
    required this.scheme,
    required this.theme,
  });

  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: SplashBlurCircle(
            size: 200,
            color: scheme.primary.withOpacity(0.16),
          ),
        ),
        Positioned(
          bottom: -80,
          right: -30,
          child: SplashBlurCircle(
            size: 220,
            color: scheme.secondary.withOpacity(0.14),
          ),
        ),
        Positioned(
          top: 140,
          right: 30,
          child: SplashBlurCircle(
            size: 100,
            color: scheme.tertiary.withOpacity(0.10),
          ),
        ),
      ],
    );
  }
}

class SplashGlassCard extends StatelessWidget {
  const SplashGlassCard({
    super.key,
    required this.glowFade,
    required this.textSlide,
    required this.title,
    required this.subtitle,
    required this.scheme,
    required this.theme,
  });

  final Animation<double> glowFade;
  final Animation<Offset> textSlide;
  final String title;
  final String subtitle;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowFade,
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
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withOpacity(0.10 * glowFade.value),
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
              border: Border.all(color: scheme.primary.withOpacity(0.14)),
            ),
            child: const AppMedia(height: 90, width: 90),
          ),
          const SizedBox(height: 22),
          SlideTransition(
            position: textSlide,
            child: Column(
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
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
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashBlurCircle extends StatelessWidget {
  const SplashBlurCircle({super.key, required this.size, required this.color});

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
