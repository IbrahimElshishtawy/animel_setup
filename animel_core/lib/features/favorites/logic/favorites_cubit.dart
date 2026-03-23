import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/storage_service.dart';

class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit() : super(<String>{});

  final StorageService _storageService = StorageService();

  Future<void> loadFavorites() async {
    final ids = await _storageService.getFavoriteAnimalIds();
    emit(ids.toSet());
  }

  Future<void> toggleAnimal(String animalId) async {
    final next = Set<String>.from(state);
    if (next.contains(animalId)) {
      next.remove(animalId);
    } else {
      next.add(animalId);
    }

    await _storageService.saveFavoriteAnimalIds(next.toList());
    emit(next);
  }

  bool isFavorite(String animalId) => state.contains(animalId);
}
