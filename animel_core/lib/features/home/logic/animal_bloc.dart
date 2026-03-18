import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/repositories/animal_repository.dart';

abstract class AnimalEvent extends Equatable {
  const AnimalEvent();

  @override
  List<Object?> get props => [];
}

class FetchAnimals extends AnimalEvent {
  final String? query;
  final String? type;

  const FetchAnimals({this.query, this.type});

  @override
  List<Object?> get props => [query, type];
}

class FetchMyAnimals extends AnimalEvent {}

class CreateAnimalRequested extends AnimalEvent {
  final Map<String, dynamic> data;

  const CreateAnimalRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateAnimalRequested extends AnimalEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateAnimalRequested(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteAnimalRequested extends AnimalEvent {
  final String id;

  const DeleteAnimalRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearAnimalMessage extends AnimalEvent {}

class AnimalState extends Equatable {
  final List<Animal> animals;
  final List<Animal> myAnimals;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const AnimalState({
    this.animals = const [],
    this.myAnimals = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  const AnimalState.initial() : this();

  AnimalState copyWith({
    List<Animal>? animals,
    List<Animal>? myAnimals,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AnimalState(
      animals: animals ?? this.animals,
      myAnimals: myAnimals ?? this.myAnimals,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        animals,
        myAnimals,
        isLoading,
        isSubmitting,
        errorMessage,
        successMessage,
      ];
}

class AnimalBloc extends Bloc<AnimalEvent, AnimalState> {
  final AnimalRepository _repository = AnimalRepository();

  AnimalBloc() : super(const AnimalState.initial()) {
    on<FetchAnimals>(_onFetchAnimals);
    on<FetchMyAnimals>(_onFetchMyAnimals);
    on<CreateAnimalRequested>(_onCreateAnimalRequested);
    on<UpdateAnimalRequested>(_onUpdateAnimalRequested);
    on<DeleteAnimalRequested>(_onDeleteAnimalRequested);
    on<ClearAnimalMessage>(
      (event, emit) => emit(
        state.copyWith(clearError: true, clearSuccess: true),
      ),
    );
  }

  Future<void> _onFetchAnimals(
    FetchAnimals event,
    Emitter<AnimalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final animals = await _repository.getAnimals(
        isForAdoption: false,
        query: event.query,
        type: event.type,
      );
      emit(state.copyWith(animals: animals, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> _onFetchMyAnimals(
    FetchMyAnimals event,
    Emitter<AnimalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final animals = await _repository.getMyAnimals();
      emit(state.copyWith(myAnimals: animals, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> _onCreateAnimalRequested(
    CreateAnimalRequested event,
    Emitter<AnimalState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      final animal = await _repository.createAnimal(event.data);
      emit(
        state.copyWith(
          isSubmitting: false,
          animals: [animal, ...state.animals],
          myAnimals: [animal, ...state.myAnimals],
          successMessage: animal.isForAdoption
              ? 'Adoption post created successfully'
              : 'Listing created successfully',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> _onUpdateAnimalRequested(
    UpdateAnimalRequested event,
    Emitter<AnimalState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      final updated = await _repository.updateAnimal(event.id, event.data);
      emit(
        state.copyWith(
          isSubmitting: false,
          animals: state.animals
              .map((animal) => animal.id == updated.id ? updated : animal)
              .toList(),
          myAnimals: state.myAnimals
              .map((animal) => animal.id == updated.id ? updated : animal)
              .toList(),
          successMessage: 'Listing updated successfully',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> _onDeleteAnimalRequested(
    DeleteAnimalRequested event,
    Emitter<AnimalState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      await _repository.deleteAnimal(event.id);
      emit(
        state.copyWith(
          isSubmitting: false,
          animals: state.animals.where((animal) => animal.id != event.id).toList(),
          myAnimals: state.myAnimals
              .where((animal) => animal.id != event.id)
              .toList(),
          successMessage: 'Listing deleted successfully',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
          clearSuccess: true,
        ),
      );
    }
  }
}
