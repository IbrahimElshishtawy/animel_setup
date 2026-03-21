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
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? child;
  final String? heroTag;
  final String fallbackAsset;

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
                  errorBuilder: (_, _, _) =>
                      Image.asset(fallbackAsset, fit: fit),
                )
              : decodedBase64Image != null
              ? Image.memory(
                  decodedBase64Image,
                  fit: fit,
                  errorBuilder: (_, _, _) => Image.asset(fallbackAsset, fit: fit),
                )
              : Image.asset(fallbackAsset, fit: fit),
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
