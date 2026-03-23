import 'package:animel_core/core/models/animal_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'animal_card.dart';

class AnimalsGrid extends StatelessWidget {
  const AnimalsGrid({super.key});

  static final animals = [
    _animal(
      id: 'grid-1',
      name: 'Luciffar',
      type: 'Cat',
      breed: 'Tabby',
      age: '2 years',
      price: 340,
      location: 'Nasr City, Cairo',
      description: 'Friendly and curious tabby with white paws.',
      healthStatus: 'Healthy',
      imageUrl:
          'https://images.pexels.com/photos/127409/pexels-photo-127409.jpeg',
    ),
    _animal(
      id: 'grid-2',
      name: 'Snow',
      type: 'Dog',
      breed: 'Samoyed',
      age: '1 year',
      price: 620,
      location: '6th of October, Giza',
      description: 'Calm and bright white companion with playful energy.',
      healthStatus: 'Vaccinated',
      imageUrl:
          'https://images.pexels.com/photos/4587995/pexels-photo-4587995.jpeg',
    ),
    _animal(
      id: 'grid-3',
      name: 'Rocky',
      type: 'Dog',
      breed: 'Mixed Breed',
      age: '3 years',
      price: 450,
      location: 'Miami, Alexandria',
      description: 'Loyal and people-friendly with a gentle temperament.',
      healthStatus: 'Ready for pickup',
      imageUrl:
          'https://images.pexels.com/photos/5731862/pexels-photo-5731862.jpeg',
    ),
    _animal(
      id: 'grid-4',
      name: 'Oreo',
      type: 'Cat',
      breed: 'Domestic Short Hair',
      age: '18 months',
      price: 0,
      location: 'Smouha, Alexandria',
      description: 'Affectionate indoor cat looking for a loving home.',
      healthStatus: 'Adoption ready',
      imageUrl:
          'https://images.pexels.com/photos/236606/pexels-photo-236606.jpeg',
      isForAdoption: true,
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
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) {
        final item = animals[index];
        return AnimalCard(
          animal: item,
          onTap: () => context.push('/animal-details', extra: item),
        );
      },
    );
  }
}

Animal _animal({
  required String id,
  required String name,
  required String type,
  required String breed,
  required String age,
  required double price,
  required String location,
  required String description,
  required String healthStatus,
  required String imageUrl,
  bool isForAdoption = false,
}) {
  return Animal(
    id: id,
    name: name,
    type: type,
    breed: breed,
    age: age,
    gender: 'Unknown',
    size: 'Medium',
    price: price,
    location: location,
    latitude: 0,
    longitude: 0,
    description: description,
    imageUrls: [imageUrl],
    isForAdoption: isForAdoption,
    ownerId: '$id-owner',
    healthStatus: healthStatus,
  );
}
