import 'package:flutter/material.dart';
import '../../../../core/widgets/already_home_dialog.dart';
import 'animals_grid.dart';

class AnimalCard extends StatelessWidget {
  final AnimalDemo data;
  const AnimalCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.status == 'Already Home') {
          showDialog(
            context: context,
            builder: (_) => const AlreadyHomeDialog(),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F1F7),
          borderRadius: BorderRadius.circular(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(data.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                if (data.status != null)
                  Positioned(
                    top: 6,
                    left: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B1A45),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        data.status!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.location,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 13,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data.timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
