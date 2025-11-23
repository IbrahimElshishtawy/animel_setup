import 'package:flutter/material.dart';
import 'animal_card.dart';

class AnimalsGrid extends StatelessWidget {
  const AnimalsGrid({super.key});

  final animals = const [
    AnimalDemo(
      name: 'Luciffar',
      imageUrl:
          'https://images.pexels.com/photos/127409/pexels-photo-127409.jpeg',
      location: 'Cairo, New City',
      timeAgo: '13 days ago',
      status: null,
    ),
    AnimalDemo(
      name: 'Luciffar',
      imageUrl:
          'https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg',
      location: 'Cairo, New City',
      timeAgo: '10 days ago',
      status: 'Already Home',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: animals.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, i) => AnimalCard(data: animals[i]),
    );
  }
}

class AnimalDemo {
  final String name, imageUrl, location, timeAgo;
  final String? status;

  const AnimalDemo({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.timeAgo,
    this.status,
  });
}
