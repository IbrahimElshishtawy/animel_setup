// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GoogleStaticMap extends StatelessWidget {
  const GoogleStaticMap({
    super.key,
    required this.address,
    this.height = 190,
    this.borderRadius = 16,
  });

  static const String _apiKey = String.fromEnvironment(
    'GOOGLE_STATIC_MAPS_API_KEY',
  );

  final String address;
  final double height;
  final double borderRadius;

  bool get _hasApiKey => _apiKey.isNotEmpty;
  bool get _hasAddress => address.trim().isNotEmpty;

  Uri _buildStaticUri() {
    return Uri.https(
      'maps.googleapis.com',
      '/maps/api/staticmap',
      {
        'center': address.trim(),
        'zoom': '15',
        'size': '600x300',
        'scale': '2',
        'markers': 'color:red|${address.trim()}',
        'key': _apiKey,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAddress) {
      return _MapFallbackCard(
        height: height,
        borderRadius: borderRadius,
        title: 'Waiting for address',
        subtitle: 'Write the address first and the map card will update here.',
        address: 'No address yet',
      );
    }

    if (!_hasApiKey) {
      return _MapFallbackCard(
        height: height,
        borderRadius: borderRadius,
        title: 'Map preview unavailable',
        subtitle:
            'Add GOOGLE_STATIC_MAPS_API_KEY with --dart-define to show the static map preview.',
        address: address.trim(),
      );
    }

    final uri = _buildStaticUri();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              uri.toString(),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return const ColoredBox(
                  color: Color(0xFFF2EDF4),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, _, _) {
                return _MapFallbackCard(
                  height: height,
                  borderRadius: borderRadius,
                  title: 'Could not load map',
                  subtitle:
                      'The location preview could not be rendered right now, but the address is still saved below.',
                  address: address.trim(),
                );
              },
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.58),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFallbackCard extends StatelessWidget {
  const _MapFallbackCard({
    required this.height,
    required this.borderRadius,
    required this.title,
    required this.subtitle,
    required this.address,
  });

  final double height;
  final double borderRadius;
  final String title;
  final String subtitle;
  final String address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8EFF4), Color(0xFFF1F2F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.map_outlined, color: scheme.primary),
            ),
            const Spacer(),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
