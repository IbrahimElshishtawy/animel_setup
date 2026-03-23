// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/localization/app_copy.dart';

class AddPhotosBox extends StatelessWidget {
  final VoidCallback onTap;
  final int photoCount;
  final int maxPhotos;

  const AddPhotosBox({
    super.key,
    required this.onTap,
    this.photoCount = 0,
    this.maxPhotos = 4,
  });

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final isFull = photoCount >= maxPhotos;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8E0D7)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF7E452A).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 22,
                color: Color(0xFF7E452A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isFull ? copy.photosSelected : copy.selectPhotos,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    copy.photoSelectionSummary(photoCount, maxPhotos),
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isFull ? copy.fullLabel : copy.addButton,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7E452A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
