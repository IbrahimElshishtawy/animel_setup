import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/repositories/animal_repository.dart';

// Events
abstract class AnimalEvent extends Equatable {
  const AnimalEvent();
  @override
  List<Object> get props => [];
}

class FetchAnimals extends AnimalEvent {
  final String? query;
  const FetchAnimals({this.query});
  @override
  List<Object> get props => [query ?? ''];
}

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
  final AnimalRepository _repository = AnimalRepository();

  AnimalBloc() : super(AnimalInitial()) {
    on<FetchAnimals>((event, emit) async {
      emit(AnimalLoading());
      try {
        final animals = await _repository.getAnimals(
          isForAdoption: false,
          query: event.query,
        );

        if (animals.isEmpty && event.query == null) {
          // Fallback to mock if empty (just for demo purposes)
          emit(const AnimalLoaded([
             Animal(
              id: '1',
              name: 'Snowy (Mock)',
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
          ]));
        } else {
          emit(AnimalLoaded(animals));
        }
      } catch (e) {
        emit(const AnimalError('Failed to fetch animals'));
      }
    });
  }
}
