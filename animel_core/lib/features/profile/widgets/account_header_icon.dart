import 'package:flutter/material.dart';

import '../../../core/widgets/app_media.dart';

class AccountHeaderIcon extends StatelessWidget {
  const AccountHeaderIcon({super.key, this.imageUrl, this.name, this.subtitle});

  final String? imageUrl;
  final String? name;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 108,
          height: 108,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF7E452A), Color(0xFFF69227)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipOval(
            child: AppMedia(
              imageUrl: imageUrl,
              fallbackImageUrl: AppMedia.profilePlaceholder,
            ),
          ),
        ),
        if ((name ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            name!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
        if ((subtitle ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
