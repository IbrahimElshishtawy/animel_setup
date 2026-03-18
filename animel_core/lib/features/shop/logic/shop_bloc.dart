import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/product_model.dart';

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
  ShopBloc() : super(ShopInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ShopLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        List<Product> mockProducts = [
          const Product(
            id: '1',
            name: 'Premium Cat Food',
            category: 'Food',
            price: 25.99,
            description: 'Nutritious food for adult cats.',
            imageUrl: 'assets/image/image.png',
            animalType: 'Cat',
          ),
          const Product(
            id: '2',
            name: 'Dog Chew Toy',
            category: 'Toys',
            price: 12.50,
            description: 'Durable rubber toy for dogs.',
            imageUrl: 'assets/image/image.png',
            animalType: 'Dog',
          ),
        ];

        if (event.query != null && event.query!.isNotEmpty) {
          mockProducts = mockProducts
              .where((p) => p.name.toLowerCase().contains(event.query!.toLowerCase()))
              .toList();
        }
        if (event.category != null && event.category != 'All') {
          mockProducts = mockProducts
              .where((p) => p.category == event.category)
              .toList();
        }

        emit(ShopLoaded(mockProducts));
      } catch (e) {
        emit(const ShopError('Failed to fetch products'));
      }
    });
  }
}
