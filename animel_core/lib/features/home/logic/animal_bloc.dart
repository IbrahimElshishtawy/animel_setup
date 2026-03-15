import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/animal_model.dart';

// Events
abstract class AnimalEvent extends Equatable {
  const AnimalEvent();
  @override
  List<Object> get props => [];
}

class FetchAnimals extends AnimalEvent {}

// States
abstract class AnimalState extends Equatable {
  const AnimalState();
  @override
  List<Object> get props => [];
}

class AnimalInitial extends AnimalState {}
class AnimalLoading extends AnimalState {}
class AnimalLoaded extends AnimalState {
  final List<Animal> animals;
  const AnimalLoaded(this.animals);
  @override
  List<Object> get props => [animals];
}
class AnimalError extends AnimalState {
  final String message;
  const AnimalError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class AnimalBloc extends Bloc<AnimalEvent, AnimalState> {
  AnimalBloc() : super(AnimalInitial()) {
    on<FetchAnimals>((event, emit) async {
      emit(AnimalLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final List<Animal> mockAnimals = [
          const Animal(
            id: '1',
            name: 'Snowy',
            type: 'Cat',
            breed: 'Persian',
            age: '2 years',
            gender: 'Female',
            size: 'Small',
            price: 500,
            location: 'New York',
            description: 'A beautiful and calm white Persian cat.',
            imageUrls: ['assets/image/image.png'],
            isForAdoption: false,
            ownerId: 'owner1',
            healthStatus: 'Vaccinated',
          ),
          const Animal(
            id: '2',
            name: 'Max',
            type: 'Dog',
            breed: 'Golden Retriever',
            age: '1 year',
            gender: 'Male',
            size: 'Large',
            price: 1200,
            location: 'Los Angeles',
            description: 'Energetic and friendly Golden Retriever.',
            imageUrls: ['assets/image/image.png'],
            isForAdoption: false,
            ownerId: 'owner2',
            healthStatus: 'Healthy',
          ),
        ];
        emit(AnimalLoaded(mockAnimals));
      } catch (e) {
        emit(const AnimalError('Failed to fetch animals'));
      }
    });
  }
}
