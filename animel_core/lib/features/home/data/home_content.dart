import 'package:flutter/material.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/models/product_model.dart';

class HomeBannerData {
  const HomeBannerData({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.route,
    required this.imageUrl,
    required this.gradientColors,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
  final String route;
  final String imageUrl;
  final List<Color> gradientColors;
}

class HomeCategoryData {
  const HomeCategoryData({
    required this.label,
    required this.icon,
    required this.tint,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final String route;
}

class HomeProductData {
  const HomeProductData({
    required this.product,
    required this.rating,
    required this.accentLabel,
  });

  final Product product;
  final double rating;
  final String accentLabel;
}

class NearbyAnimalData {
  const NearbyAnimalData({
    required this.animal,
    required this.distance,
    required this.typeLabel,
  });

  final Animal animal;
  final String distance;
  final String typeLabel;
}

class NearbyServiceData {
  const NearbyServiceData({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.rating,
    required this.icon,
    required this.accent,
    required this.isOnline,
  });

  final String title;
  final String subtitle;
  final String badge;
  final double rating;
  final IconData icon;
  final Color accent;
  final bool isOnline;
}

class HomeContent {
  HomeContent._();

  static const List<HomeBannerData> banners = [
    HomeBannerData(
      title: 'Trusted companions for every kind of home',
      subtitle:
          'Premium listings, careful adoption stories, and verified sellers in one calm marketplace.',
      ctaLabel: 'Explore pets',
      route: '/animal-list',
      imageUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1400&q=80',
      gradientColors: [Color(0xFF123946), Color(0xFF2A7C7E), Color(0xFFE2B07C)],
    ),
    HomeBannerData(
      title: 'Urgent adoption, handled with more care',
      subtitle:
          'Meet animals that need a home quickly and connect with people you can trust.',
      ctaLabel: 'Adopt now',
      route: '/adopt',
      imageUrl:
          'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=1400&q=80',
      gradientColors: [Color(0xFF3D5447), Color(0xFF5B8B73), Color(0xFFF0C18B)],
    ),
    HomeBannerData(
      title: 'Food, accessories, and nearby helpers',
      subtitle:
          'Stock up on everyday supplies and discover groomers, walkers, and sitters around you.',
      ctaLabel: 'View essentials',
      route: '/shop',
      imageUrl:
          'https://images.unsplash.com/photo-1583512603806-077998240c7a?auto=format&fit=crop&w=1400&q=80',
      gradientColors: [Color(0xFF24324B), Color(0xFF5B7A8D), Color(0xFFD8B788)],
    ),
  ];

  static const List<HomeCategoryData> categories = [
    HomeCategoryData(
      label: 'Pets',
      icon: Icons.pets_rounded,
      tint: Color(0xFFFFE2C2),
      route: '/animal-list',
    ),
    HomeCategoryData(
      label: 'Adoption',
      icon: Icons.favorite_rounded,
      tint: Color(0xFFFFD8D3),
      route: '/adopt',
    ),
    HomeCategoryData(
      label: 'Food',
      icon: Icons.restaurant_rounded,
      tint: Color(0xFFD6F0DE),
      route: '/shop',
    ),
    HomeCategoryData(
      label: 'Accessories',
      icon: Icons.shopping_bag_rounded,
      tint: Color(0xFFDCEAF7),
      route: '/shop',
    ),
    HomeCategoryData(
      label: 'Services',
      icon: Icons.room_service_rounded,
      tint: Color(0xFFE6E1FB),
      route: '/map',
    ),
  ];

  static final List<Animal> featuredAnimals = [
    _animal(
      id: 'home-featured-1',
      name: 'Golden Retriever Puppy',
      type: 'Dog',
      breed: 'Golden Retriever',
      price: 1200,
      location: 'New Cairo',
      description:
          'Playful, social, and already used to a family routine with vet records ready.',
      healthStatus: 'Vaccinated and wellness checked',
      age: '4 months',
      gender: 'Male',
      size: 'Medium',
      latitude: 30.020,
      longitude: 31.490,
      imageUrls: const [
        'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-1',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _animal(
      id: 'home-featured-2',
      name: 'Scottish Fold Kitten',
      type: 'Cat',
      breed: 'Scottish Fold',
      price: 950,
      location: 'Maadi',
      description:
          'Gentle indoor kitten with a calm temperament and full starter care kit.',
      healthStatus: 'Dewormed and vaccinated',
      age: '3 months',
      gender: 'Female',
      size: 'Small',
      latitude: 29.960,
      longitude: 31.255,
      imageUrls: const [
        'https://images.unsplash.com/photo-1511044568932-338cba0ad803?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-2',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    _animal(
      id: 'home-featured-3',
      name: 'Blue-and-Gold Macaw',
      type: 'Bird',
      breed: 'Macaw',
      price: 1750,
      location: 'Nasr City',
      description:
          'Smart, social bird with a monitored diet and training routine for indoor living.',
      healthStatus: 'Microchipped and documented',
      age: '1 year',
      gender: 'Female',
      size: 'Medium',
      latitude: 30.060,
      longitude: 31.340,
      imageUrls: const [
        'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-3',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    _animal(
      id: 'home-featured-4',
      name: 'Mini Lop Rabbit',
      type: 'Rabbit',
      breed: 'Mini Lop',
      price: 0,
      location: 'Zayed',
      description:
          'Sweet rabbit looking for a quiet adopter with indoor space and gentle care.',
      healthStatus: 'Healthy and adoption ready',
      age: '11 months',
      gender: 'Male',
      size: 'Small',
      latitude: 30.050,
      longitude: 30.980,
      imageUrls: const [
        'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-featured-4',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
  ];

  static final List<NearbyAnimalData> nearbyAnimals = [
    NearbyAnimalData(
      animal: featuredAnimals[0],
      distance: '0.9 km',
      typeLabel: 'For sale',
    ),
    NearbyAnimalData(
      animal: featuredAnimals[1],
      distance: '1.6 km',
      typeLabel: 'New listing',
    ),
    NearbyAnimalData(
      animal: featuredAnimals[3],
      distance: '2.4 km',
      typeLabel: 'Urgent adoption',
    ),
  ];

  static final List<Animal> adoptionSpotlights = [
    _animal(
      id: 'home-adoption-1',
      name: 'Milo',
      type: 'Dog',
      breed: 'Golden Retriever',
      price: 0,
      location: 'Heliopolis',
      description:
          'Gentle, playful, and great with children. He needs a family home within the week.',
      healthStatus: 'Vaccinated and socialized',
      age: '3 years',
      gender: 'Male',
      size: 'Large',
      latitude: 30.091,
      longitude: 31.330,
      imageUrls: const [
        'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-adoption-1',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    _animal(
      id: 'home-adoption-2',
      name: 'Luna',
      type: 'Cat',
      breed: 'British Shorthair',
      price: 0,
      location: 'Dokki',
      description:
          'Calm indoor cat with a soft temperament and a complete health record ready to share.',
      healthStatus: 'Spayed and fully vaccinated',
      age: '18 months',
      gender: 'Female',
      size: 'Small',
      latitude: 30.040,
      longitude: 31.210,
      imageUrls: const [
        'https://images.unsplash.com/photo-1519052537078-e6302a4968d4?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-adoption-2',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    _animal(
      id: 'home-adoption-3',
      name: 'Coco',
      type: 'Dog',
      breed: 'Mixed Breed',
      price: 0,
      location: 'Sheikh Zayed',
      description:
          'A resilient rescue dog who is affectionate, house-trained, and ready for a calm space.',
      healthStatus: 'Recovering well and monitored weekly',
      age: '2 years',
      gender: 'Female',
      size: 'Medium',
      latitude: 30.030,
      longitude: 30.970,
      imageUrls: const [
        'https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-adoption-3',
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
    ),
  ];

  static const List<HomeProductData> products = [
    HomeProductData(
      product: Product(
        id: 'home-product-1',
        name: 'Grain-Free Daily Nutrition',
        category: 'Food',
        price: 28,
        description: 'Balanced dry food for young and adult dogs.',
        imageUrl:
            'https://images.unsplash.com/photo-1598137269392-7ccfd8e2ea2f?auto=format&fit=crop&w=900&q=80',
        animalType: 'Dogs',
        stock: 14,
      ),
      rating: 4.8,
      accentLabel: 'Best seller',
    ),
    HomeProductData(
      product: Product(
        id: 'home-product-2',
        name: 'Cloud Soft Carrier',
        category: 'Accessories',
        price: 64,
        description: 'Breathable carrier with soft lining and secure support.',
        imageUrl:
            'https://images.unsplash.com/photo-1548767797-d8c844163c4c?auto=format&fit=crop&w=900&q=80',
        animalType: 'Cats & small pets',
        stock: 9,
      ),
      rating: 4.7,
      accentLabel: 'Editor pick',
    ),
    HomeProductData(
      product: Product(
        id: 'home-product-3',
        name: 'Interactive Enrichment Toy',
        category: 'Accessories',
        price: 22,
        description:
            'A premium toy that keeps pets engaged throughout the day.',
        imageUrl:
            'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=900&q=80',
        animalType: 'Dogs & cats',
        stock: 23,
      ),
      rating: 4.9,
      accentLabel: 'Top rated',
    ),
    HomeProductData(
      product: Product(
        id: 'home-product-4',
        name: 'Natural Wellness Bowl Set',
        category: 'Food',
        price: 31,
        description: 'A ceramic feeding set with a calm, modern finish.',
        imageUrl:
            'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=900&q=80',
        animalType: 'All pets',
        stock: 6,
      ),
      rating: 4.6,
      accentLabel: 'New',
    ),
  ];

  static const List<NearbyServiceData> serviceHelpers = [
    NearbyServiceData(
      title: 'Nour Pet Grooming',
      subtitle: 'Mobile grooming and coat care',
      badge: '12 min away',
      rating: 4.9,
      icon: Icons.content_cut_rounded,
      accent: Color(0xFF7AA39E),
      isOnline: true,
    ),
    NearbyServiceData(
      title: 'Amina Pet Sitter',
      subtitle: 'Trusted boarding and home visits',
      badge: 'Available today',
      rating: 4.8,
      icon: Icons.home_work_outlined,
      accent: Color(0xFFDAA46D),
      isOnline: true,
    ),
    NearbyServiceData(
      title: 'Happy Paws Walker',
      subtitle: 'Morning and evening dog walks',
      badge: '2.7 km',
      rating: 4.7,
      icon: Icons.directions_walk_rounded,
      accent: Color(0xFF6E8D9D),
      isOnline: false,
    ),
  ];

  static Animal _animal({
    required String id,
    required String name,
    required String type,
    required String breed,
    required double price,
    required String location,
    required String description,
    required String healthStatus,
    required String age,
    required String gender,
    required String size,
    required double latitude,
    required double longitude,
    required List<String> imageUrls,
    required bool isForAdoption,
    required String ownerId,
    required DateTime createdAt,
  }) {
    return Animal(
      id: id,
      name: name,
      type: type,
      breed: breed,
      age: age,
      gender: gender,
      size: size,
      price: price,
      location: location,
      latitude: latitude,
      longitude: longitude,
      description: description,
      imageUrls: imageUrls,
      isForAdoption: isForAdoption,
      ownerId: ownerId,
      healthStatus: healthStatus,
      createdAt: createdAt,
    );
  }
}
