import 'package:animel_core/features/home/data/animal_demo.dart';
import 'package:flutter/material.dart';
import 'animal_card.dart';

class AnimalsGrid extends StatelessWidget {
  const AnimalsGrid({super.key});

  final animals = const [
    AnimalDemo(
      name: 'Luciffar',
      imageUrl:
          'https://images.pexels.com/photos/127409/pexels-photo-127409.jpeg',
      location: 'Cairo, New City, 11th St...',
      timeAgo: '13 days ago',
      status: null,
    ),
    AnimalDemo(
      name: 'Luciffar',
      imageUrl:
          'https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg',
      location: 'Cairo, New City, 11th St...',
      timeAgo: '10 days ago',
      status: 'Already Home',
    ),
    AnimalDemo(
      name: 'Snow',
      imageUrl:
          'https://images.pexels.com/photos/4587995/pexels-photo-4587995.jpeg',
      location: 'Giza, 6th of October',
      timeAgo: '5 days ago',
      status: null,
    ),
    AnimalDemo(
      name: 'Rocky',
      imageUrl:
          'https://images.pexels.com/photos/5731862/pexels-photo-5731862.jpeg',
      location: 'Alexandria, Miami',
      timeAgo: '2 days ago',
      status: null,
    ),
    AnimalDemo(
      name: 'Milo',
      imageUrl:
          'https://images.pexels.com/photos/1390361/pexels-photo-1390361.jpeg',
      location: 'Cairo Downtown',
      timeAgo: '1 day ago',
      status: null,
    ),
    AnimalDemo(
      name: 'Bella',
      imageUrl:
          'https://images.pexels.com/photos/208984/pexels-photo-208984.jpeg',
      location: 'Nasr City',
      timeAgo: '7 days ago',
      status: 'Already Home',
    ),
    AnimalDemo(
      name: 'Shadow',
      imageUrl:
          'https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg',
      location: 'Giza – Haram',
      timeAgo: '3 days ago',
      status: null,
    ),
    AnimalDemo(
      name: 'Oreo',
      imageUrl:
          'https://images.pexels.com/photos/236606/pexels-photo-236606.jpeg',
      location: 'Alex – Smouha',
      timeAgo: '12 days ago',
      status: null,
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
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final item = animals[index];
        return AnimalCard(data: item);
      },
    );
  }
}
