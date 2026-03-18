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
  final String? type;
  const FetchAnimals({this.query, this.type});
  @override
  List<Object> get props => [query ?? '', type ?? ''];
}

class CreateAnimalRequested extends AnimalEvent {
  final Map<String, dynamic> data;
  const CreateAnimalRequested(this.data);
  @override
  List<Object> get props => [data];
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
          type: event.type,
        );
        emit(AnimalLoaded(animals));
      } catch (e) {
        emit(const AnimalError('Failed to fetch animals'));
      }
    });

    on<CreateAnimalRequested>((event, emit) async {
      try {
        final animal = await _repository.createAnimal(event.data);
        if (animal != null) {
          add(const FetchAnimals());
        }
      } catch (e) {
        // Handle error
      }
    });
  }
}
