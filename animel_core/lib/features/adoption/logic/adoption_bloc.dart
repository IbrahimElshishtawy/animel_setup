import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/repositories/adoption_repository.dart';

// Events
abstract class AdoptionEvent extends Equatable {
  const AdoptionEvent();
  @override
  List<Object> get props => [];
}

class FetchAdoptionAnimals extends AdoptionEvent {
  final String? query;
  const FetchAdoptionAnimals({this.query});
  @override
  List<Object> get props => [query ?? ''];
}

class CreateAdoptionPostRequested extends AdoptionEvent {
  final Map<String, dynamic> data;
  const CreateAdoptionPostRequested(this.data);
  @override
  List<Object> get props => [data];
}

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
  final AdoptionRepository _adoptionRepository = AdoptionRepository();

  AdoptionBloc() : super(AdoptionInitial()) {
    on<FetchAdoptionAnimals>((event, emit) async {
      emit(AdoptionLoading());
      try {
        final animals = await _adoptionRepository.getAdoptionAnimals(query: event.query);
        emit(AdoptionLoaded(animals));
      } catch (e) {
        emit(const AdoptionError('Failed to fetch adoption animals'));
      }
    });

    on<CreateAdoptionPostRequested>((event, emit) async {
      try {
        final post = await _adoptionRepository.createAdoptionPost(event.data);
        if (post != null) {
          add(const FetchAdoptionAnimals());
        }
      } catch (e) {
        // Handle error
      }
    });
  }
}
