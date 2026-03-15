import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/animal_model.dart';

// Events
abstract class AdoptionEvent extends Equatable {
  const AdoptionEvent();
  @override
  List<Object> get props => [];
}

class FetchAdoptionAnimals extends AdoptionEvent {}

// States
abstract class AdoptionState extends Equatable {
  const AdoptionState();
  @override
  List<Object> get props => [];
}

class AdoptionInitial extends AdoptionState {}
class AdoptionLoading extends AdoptionState {}
class AdoptionLoaded extends AdoptionState {
  final List<Animal> animals;
  const AdoptionLoaded(this.animals);
  @override
  List<Object> get props => [animals];
}
class AdoptionError extends AdoptionState {
  final String message;
  const AdoptionError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  AdoptionBloc() : super(AdoptionInitial()) {
    on<FetchAdoptionAnimals>((event, emit) async {
      emit(AdoptionLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final List<Animal> mockAdoptionAnimals = [
          const Animal(
            id: '3',
            name: 'Buddy',
            type: 'Dog',
            breed: 'Beagle',
            age: '3 years',
            gender: 'Male',
            size: 'Medium',
            price: 0,
            location: 'Chicago',
            description: 'A very friendly beagle looking for a home.',
            imageUrls: ['assets/image/image.png'],
            isForAdoption: true,
            ownerId: 'shelter1',
            healthStatus: 'Vaccinated & Neutered',
          ),
        ];
        emit(AdoptionLoaded(mockAdoptionAnimals));
      } catch (e) {
        emit(const AdoptionError('Failed to fetch adoption animals'));
      }
    });
  }
}
