import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppMedia extends StatelessWidget {
  const AppMedia({
    super.key,
    this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.child,
    this.heroTag,
    this.fallbackAsset = 'assets/image/image.png',
    this.fallbackImageUrl,
  });

  static const String animalPlaceholder =
      'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=1200&q=80';
  static const String productPlaceholder =
      'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?auto=format&fit=crop&w=1200&q=80';
  static const String profilePlaceholder =
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80';

  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? child;
  final String? heroTag;
  final String fallbackAsset;
  final String? fallbackImageUrl;

  bool get _hasNetworkImage =>
      imageUrl != null && imageUrl!.isNotEmpty && imageUrl!.startsWith('http');
  bool get _hasBase64Image =>
      imageUrl != null &&
      imageUrl!.isNotEmpty &&
      imageUrl!.startsWith('data:image/');

  Uint8List? get _decodedBase64Image {
    if (!_hasBase64Image) return null;

    try {
      final commaIndex = imageUrl!.indexOf(',');
      if (commaIndex == -1) return null;
      return base64Decode(imageUrl!.substring(commaIndex + 1));
    } catch (_) {
      return null;
    }
  }

  Widget _buildFallback(BuildContext context) {
    if (fallbackImageUrl != null && fallbackImageUrl!.isNotEmpty) {
      return Image.network(
        fallbackImageUrl!,
        fit: fit,
        errorBuilder: (_, _, _) => _buildFallbackSurface(context),
      );
    }

    return Image.asset(
      fallbackAsset,
      fit: fit,
      errorBuilder: (_, _, _) => _buildFallbackSurface(context),
    );
  }

  Widget _buildFallbackSurface(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.14),
            scheme.secondary.withValues(alpha: 0.08),
            scheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decodedBase64Image = _decodedBase64Image;

    Widget image = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _hasNetworkImage
              ? Image.network(
                  imageUrl!,
                  fit: fit,
                  errorBuilder: (_, _, _) => _buildFallback(context),
                )
              : decodedBase64Image != null
              ? Image.memory(
                  decodedBase64Image,
                  fit: fit,
                  errorBuilder: (_, _, _) => _buildFallback(context),
                )
              : _buildFallback(context),
          ?child,
        ],
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return SizedBox(height: height, width: width, child: image);
  }
}
