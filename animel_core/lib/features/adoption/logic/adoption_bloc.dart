import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/adoption_request_model.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/repositories/adoption_repository.dart';

abstract class AdoptionEvent extends Equatable {
  const AdoptionEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdoptionAnimals extends AdoptionEvent {
  final String? query;

  const FetchAdoptionAnimals({this.query});

  @override
  List<Object?> get props => [query];
}

class CreateAdoptionPostRequested extends AdoptionEvent {
  final Map<String, dynamic> data;

  const CreateAdoptionPostRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class SubmitAdoptionRequest extends AdoptionEvent {
  final String animalId;
  final String message;

  const SubmitAdoptionRequest(this.animalId, this.message);

  @override
  List<Object?> get props => [animalId, message];
}

class FetchSentAdoptionRequests extends AdoptionEvent {}

class FetchReceivedAdoptionRequests extends AdoptionEvent {}

class UpdateAdoptionRequestStatus extends AdoptionEvent {
  final String requestId;
  final String status;

  const UpdateAdoptionRequestStatus(this.requestId, this.status);

  @override
  List<Object?> get props => [requestId, status];
}

class ClearAdoptionMessage extends AdoptionEvent {}

class AdoptionState extends Equatable {
  final List<Animal> animals;
  final List<AdoptionRequestModel> sentRequests;
  final List<AdoptionRequestModel> receivedRequests;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const AdoptionState({
    this.animals = const [],
    this.sentRequests = const [],
    this.receivedRequests = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  const AdoptionState.initial() : this();

  AdoptionState copyWith({
    List<Animal>? animals,
    List<AdoptionRequestModel>? sentRequests,
    List<AdoptionRequestModel>? receivedRequests,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AdoptionState(
      animals: animals ?? this.animals,
      sentRequests: sentRequests ?? this.sentRequests,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        animals,
        sentRequests,
        receivedRequests,
        isLoading,
        isSubmitting,
        errorMessage,
        successMessage,
      ];
}

class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  final AdoptionRepository _repository = AdoptionRepository();

  AdoptionBloc() : super(const AdoptionState.initial()) {
    on<FetchAdoptionAnimals>(_onFetchAdoptionAnimals);
    on<CreateAdoptionPostRequested>(_onCreateAdoptionPostRequested);
    on<SubmitAdoptionRequest>(_onSubmitAdoptionRequest);
    on<FetchSentAdoptionRequests>(_onFetchSentAdoptionRequests);
    on<FetchReceivedAdoptionRequests>(_onFetchReceivedAdoptionRequests);
    on<UpdateAdoptionRequestStatus>(_onUpdateAdoptionRequestStatus);
    on<ClearAdoptionMessage>(
      (event, emit) => emit(state.copyWith(clearError: true, clearSuccess: true)),
    );
  }

  Future<void> _onFetchAdoptionAnimals(
    FetchAdoptionAnimals event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final animals = await _repository.getAdoptionAnimals(query: event.query);
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

  Future<void> _onCreateAdoptionPostRequested(
    CreateAdoptionPostRequested event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      final animal = await _repository.createAdoptionPost(event.data);
      emit(
        state.copyWith(
          isSubmitting: false,
          animals: [animal, ...state.animals],
          successMessage: 'Adoption post created successfully',
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

  Future<void> _onSubmitAdoptionRequest(
    SubmitAdoptionRequest event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      final request = await _repository.sendAdoptionRequest(
        event.animalId,
        event.message,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          sentRequests: [request, ...state.sentRequests],
          successMessage: 'Adoption request sent successfully',
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

  Future<void> _onFetchSentAdoptionRequests(
    FetchSentAdoptionRequests event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final requests = await _repository.getSentRequests();
      emit(state.copyWith(sentRequests: requests, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onFetchReceivedAdoptionRequests(
    FetchReceivedAdoptionRequests event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final requests = await _repository.getReceivedRequests();
      emit(state.copyWith(receivedRequests: requests, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onUpdateAdoptionRequestStatus(
    UpdateAdoptionRequestStatus event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      final request = await _repository.updateRequestStatus(
        event.requestId,
        event.status,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          receivedRequests: state.receivedRequests
              .map((item) => item.id == request.id ? request : item)
              .toList(),
          successMessage: 'Adoption request updated',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }
}
