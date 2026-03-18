import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/product_model.dart';
import '../../../core/repositories/shop_repository.dart';

// Events
abstract class ShopEvent extends Equatable {
  const ShopEvent();
  @override
  List<Object> get props => [];
}

class FetchProducts extends ShopEvent {
  final String? query;
  final String? category;
  const FetchProducts({this.query, this.category});
  @override
  List<Object> get props => [query ?? '', category ?? ''];
}

// States
abstract class ShopState extends Equatable {
  const ShopState();
  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {}
class ShopLoading extends ShopState {}
class ShopLoaded extends ShopState {
  final List<Product> products;
  const ShopLoaded(this.products);
  @override
  List<Object> get props => [products];
}
class ShopError extends ShopState {
  final String message;
  const ShopError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _shopRepository = ShopRepository();

  ShopBloc() : super(ShopInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ShopLoading());
      try {
        final products = await _shopRepository.getProducts(query: event.query, category: event.category);
        emit(ShopLoaded(products));
      } catch (e) {
        emit(const ShopError('Failed to fetch products'));
      }
    });
  }
}
