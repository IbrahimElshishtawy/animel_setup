import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

enum UserJourney { petOwner, buyer, adopter }

extension UserJourneyX on UserJourney {
  String get storageValue {
    switch (this) {
      case UserJourney.petOwner:
        return 'pet_owner';
      case UserJourney.buyer:
        return 'buyer';
      case UserJourney.adopter:
        return 'adopter';
    }
  }

  String get title {
    switch (this) {
      case UserJourney.petOwner:
        return 'I have a pet';
      case UserJourney.buyer:
        return 'I want to buy';
      case UserJourney.adopter:
        return 'I want to adopt';
    }
  }

  String get subtitle {
    switch (this) {
      case UserJourney.petOwner:
        return 'Build a profile for your companion, manage details, and keep everything in one place.';
      case UserJourney.buyer:
        return 'Browse sale listings with a calmer, more guided discovery experience.';
      case UserJourney.adopter:
        return 'Find adoption-ready animals, trusted contacts, and nearby community help.';
    }
  }

  String get profileSummary {
    switch (this) {
      case UserJourney.petOwner:
        return 'Pet owner with room to manage pets and their profiles';
      case UserJourney.buyer:
        return 'Focused on browsing pets available for sale';
      case UserJourney.adopter:
        return 'Focused on adoption-ready pets and rescue journeys';
    }
  }

  String get primaryActionLabel {
    switch (this) {
      case UserJourney.petOwner:
        return 'Continue to pet setup';
      case UserJourney.buyer:
        return 'Browse pets for sale';
      case UserJourney.adopter:
        return 'Explore adoptions';
    }
  }

  String get secondaryActionLabel {
    switch (this) {
      case UserJourney.petOwner:
        return 'I will add my pet later';
      case UserJourney.buyer:
      case UserJourney.adopter:
        return 'Maybe later';
    }
  }

  String get completionTitle {
    switch (this) {
      case UserJourney.petOwner:
        return 'Your pet space is ready';
      case UserJourney.buyer:
        return 'Your browsing experience is ready';
      case UserJourney.adopter:
        return 'Your adoption journey is ready';
    }
  }

  IconData get icon {
    switch (this) {
      case UserJourney.petOwner:
        return Icons.pets_rounded;
      case UserJourney.buyer:
        return Icons.storefront_rounded;
      case UserJourney.adopter:
        return Icons.favorite_rounded;
    }
  }

  Color get accent {
    switch (this) {
      case UserJourney.petOwner:
        return AppPalette.plum;
      case UserJourney.buyer:
        return AppPalette.sunset;
      case UserJourney.adopter:
        return AppPalette.indigo;
    }
  }

  String get destinationRoute {
    switch (this) {
      case UserJourney.petOwner:
        return '/profile/pets/add-step1';
      case UserJourney.buyer:
        return '/animal-list';
      case UserJourney.adopter:
        return '/adopt';
    }
  }

  static UserJourney? fromStorage(String? value) {
    switch (value) {
      case 'pet_owner':
        return UserJourney.petOwner;
      case 'buyer':
        return UserJourney.buyer;
      case 'adopter':
        return UserJourney.adopter;
      default:
        return null;
    }
  }
}
