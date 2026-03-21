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

class HomeContent {
  HomeContent._();

  static const List<HomeBannerData> banners = [
    HomeBannerData(
      title: 'Rare companions, curated with care',
      subtitle: 'Explore standout listings for exotic and premium animals.',
      ctaLabel: 'Explore',
      route: '/animal-list',
      imageUrl:
          'https://images.unsplash.com/photo-1548767797-d8c844163c4c?auto=format&fit=crop&w=1200&q=80',
      gradientColors: [Color(0xFF1C3C54), Color(0xFF2D6A8B), Color(0xFF5BB5C6)],
    ),
    HomeBannerData(
      title: 'Give a waiting friend a home',
      subtitle: 'Meet adoption-ready animals and connect with trusted caretakers.',
      ctaLabel: 'Adopt',
      route: '/adopt',
      imageUrl:
          'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=1200&q=80',
      gradientColors: [Color(0xFF7B3E3E), Color(0xFFBA7A56), Color(0xFFE7B46E)],
    ),
    HomeBannerData(
      title: 'Premium food and essentials',
      subtitle: 'Discover daily care, wellness, and enrichment for every pet.',
      ctaLabel: 'Shop',
      route: '/shop',
      imageUrl:
          'https://images.unsplash.com/photo-1583512603806-077998240c7a?auto=format&fit=crop&w=1200&q=80',
      gradientColors: [Color(0xFF2D3047), Color(0xFF4F5D95), Color(0xFF7A8CCB)],
    ),
  ];

  static const List<HomeCategoryData> categories = [
    HomeCategoryData(
      label: 'Animals',
      icon: Icons.pets_rounded,
      tint: Color(0xFFE9D8A6),
      route: '/animal-list',
    ),
    HomeCategoryData(
      label: 'Adoption',
      icon: Icons.favorite_rounded,
      tint: Color(0xFFF4C7AB),
      route: '/adopt',
    ),
    HomeCategoryData(
      label: 'Food',
      icon: Icons.dining_rounded,
      tint: Color(0xFFCDE7BE),
      route: '/shop',
    ),
    HomeCategoryData(
      label: 'Accessories',
      icon: Icons.shopping_bag_rounded,
      tint: Color(0xFFD8D4F2),
      route: '/shop',
    ),
    HomeCategoryData(
      label: 'Nearby',
      icon: Icons.explore_rounded,
      tint: Color(0xFFBEE4E8),
      route: '/map',
    ),
  ];

  static final List<Animal> featuredAnimals = [
    _animal(
      id: 'home-featured-1',
      name: 'Astra',
      type: 'Macaw',
      breed: 'Blue-and-gold Macaw',
      price: 4200,
      location: 'Dubai Marina',
      description:
          'A social and well-trained macaw with a vibrant personality and premium care routine.',
      healthStatus: 'Vet checked and fully documented',
      age: '2 years',
      gender: 'Female',
      size: 'Medium',
      latitude: 25.080,
      longitude: 55.140,
      imageUrls: const [
        'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-1',
    ),
    _animal(
      id: 'home-featured-2',
      name: 'Nilo',
      type: 'Fennec Fox',
      breed: 'Desert Fennec',
      price: 6800,
      location: 'Abu Dhabi',
      description:
          'Rare, elegant, and raised in a controlled environment with nutrition tracking.',
      healthStatus: 'Microchipped and wellness monitored',
      age: '1 year',
      gender: 'Male',
      size: 'Small',
      latitude: 24.453,
      longitude: 54.377,
      imageUrls: const [
        'https://images.unsplash.com/photo-1516934024742-b461fba47600?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-2',
    ),
    _animal(
      id: 'home-featured-3',
      name: 'Nova',
      type: 'Savannah Cat',
      breed: 'F1 Savannah',
      price: 5300,
      location: 'Riyadh',
      description:
          'A striking rare-breed companion known for intelligence, energy, and elegant markings.',
      healthStatus: 'Vaccinated and indoor raised',
      age: '8 months',
      gender: 'Female',
      size: 'Medium',
      latitude: 24.713,
      longitude: 46.675,
      imageUrls: const [
        'https://images.unsplash.com/photo-1511044568932-338cba0ad803?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-3',
    ),
    _animal(
      id: 'home-featured-4',
      name: 'Kai',
      type: 'Koi',
      breed: 'Premium Japanese Koi',
      price: 2900,
      location: 'Doha',
      description:
          'A premium ornamental koi selected for color depth, movement, and balanced growth.',
      healthStatus: 'Water-tested and transport ready',
      age: '14 months',
      gender: 'Male',
      size: 'Small',
      latitude: 25.285,
      longitude: 51.531,
      imageUrls: const [
        'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: false,
      ownerId: 'owner-featured-4',
    ),
  ];

  static final List<NearbyAnimalData> nearbyAnimals = [
    NearbyAnimalData(
      animal: featuredAnimals[0],
      distance: '1.4 km',
      typeLabel: 'For Sale',
    ),
    NearbyAnimalData(
      animal: featuredAnimals[1],
      distance: '2.1 km',
      typeLabel: 'Rare',
    ),
    NearbyAnimalData(
      animal: featuredAnimals[2],
      distance: '3.8 km',
      typeLabel: 'For Sale',
    ),
  ];

  static final List<Animal> adoptionSpotlights = [
    _animal(
      id: 'home-adoption-1',
      name: 'Milo',
      type: 'Dog',
      breed: 'Golden Retriever',
      price: 0,
      location: 'New Cairo',
      description:
          'Gentle, playful, and great with children. Looking for a calm family home.',
      healthStatus: 'Vaccinated and socialized',
      age: '3 years',
      gender: 'Male',
      size: 'Large',
      latitude: 30.010,
      longitude: 31.490,
      imageUrls: const [
        'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-adoption-1',
    ),
    _animal(
      id: 'home-adoption-2',
      name: 'Luna',
      type: 'Cat',
      breed: 'British Shorthair',
      price: 0,
      location: 'Maadi',
      description:
          'Calm indoor cat with a soft temperament. Perfect for apartment living.',
      healthStatus: 'Spayed and fully vaccinated',
      age: '18 months',
      gender: 'Female',
      size: 'Small',
      latitude: 29.960,
      longitude: 31.258,
      imageUrls: const [
        'https://images.unsplash.com/photo-1519052537078-e6302a4968d4?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-adoption-2',
    ),
    _animal(
      id: 'home-adoption-3',
      name: 'Pico',
      type: 'Rabbit',
      breed: 'Holland Lop',
      price: 0,
      location: 'Zayed',
      description:
          'Sweet and curious with a gentle routine. Needs a quiet, attentive adopter.',
      healthStatus: 'Healthy and monitored weekly',
      age: '11 months',
      gender: 'Male',
      size: 'Small',
      latitude: 30.030,
      longitude: 30.970,
      imageUrls: const [
        'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=900&q=80',
      ],
      isForAdoption: true,
      ownerId: 'owner-adoption-3',
    ),
  ];

  static const List<HomeProductData> products = [
    HomeProductData(
      product: Product(
        id: 'home-product-1',
        name: 'Organic Bird Nutrition Mix',
        category: 'Food',
        price: 28,
        description: 'Premium seeds and nutrients for rare birds.',
        imageUrl:
            'https://images.unsplash.com/photo-1598137269392-7ccfd8e2ea2f?auto=format&fit=crop&w=900&q=80',
        animalType: 'Birds',
        stock: 14,
      ),
      rating: 4.8,
      accentLabel: 'Best Seller',
    ),
    HomeProductData(
      product: Product(
        id: 'home-product-2',
        name: 'Desert Habitat Comfort Bed',
        category: 'Accessories',
        price: 64,
        description: 'Soft, durable bedding for small exotic companions.',
        imageUrl:
            'https://images.unsplash.com/photo-1548767797-d8c844163c4c?auto=format&fit=crop&w=900&q=80',
        animalType: 'Foxes',
        stock: 9,
      ),
      rating: 4.6,
      accentLabel: 'Editor Pick',
    ),
    HomeProductData(
      product: Product(
        id: 'home-product-3',
        name: 'Aquatic Balance Care Kit',
        category: 'Wellness',
        price: 39,
        description: 'Water treatment essentials and koi health support.',
        imageUrl:
            'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?auto=format&fit=crop&w=900&q=80',
        animalType: 'Fish',
        stock: 23,
      ),
      rating: 4.9,
      accentLabel: 'Top Rated',
    ),
    HomeProductData(
      product: Product(
        id: 'home-product-4',
        name: 'Luxury Travel Carrier',
        category: 'Accessories',
        price: 89,
        description: 'Premium carrier with soft lining and airflow panels.',
        imageUrl:
            'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=900&q=80',
        animalType: 'Cats & Small Pets',
        stock: 6,
      ),
      rating: 4.7,
      accentLabel: 'New',
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
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    );
  }
}
