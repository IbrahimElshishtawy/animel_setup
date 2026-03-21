// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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
    final isFull = photoCount >= maxPhotos;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFFFDF7FF),
          border: Border.all(color: const Color(0xFFDAC4E4)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4B1A45).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 24,
                color: Color(0xFF4B1A45),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isFull ? 'Photos selected' : 'Select photos',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$photoCount / $maxPhotos selected from your phone',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isFull ? 'Full' : 'Add',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B1A45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
