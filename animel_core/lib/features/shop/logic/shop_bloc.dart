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
  final String? animalType;
  const FetchProducts({this.query, this.category, this.animalType});
  @override
  List<Object> get props => [query ?? '', category ?? '', animalType ?? ''];
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
            imageUrl:
                'https://images.pexels.com/photos/4587995/pexels-photo-4587995.jpeg?auto=compress&cs=tinysrgb&w=1200',
            animalType: 'Cat',
          ),
          const Product(
            id: '2',
            name: 'Dog Chew Toy',
            category: 'Toys',
            price: 12.50,
            description: 'Durable rubber toy for dogs.',
            imageUrl:
                'https://images.pexels.com/photos/4498185/pexels-photo-4498185.jpeg?auto=compress&cs=tinysrgb&w=1200',
            animalType: 'Dog',
          ),
          const Product(
            id: '3',
            name: 'Bird Vitamin Mix',
            category: 'Medicine',
            price: 18.75,
            description: 'Daily wellness support for parrots and small birds.',
            imageUrl:
                'https://images.pexels.com/photos/1661179/pexels-photo-1661179.jpeg?auto=compress&cs=tinysrgb&w=1200',
            animalType: 'Bird',
          ),
          const Product(
            id: '4',
            name: 'Cat Litter Box',
            category: 'Accessories',
            price: 31.00,
            description: 'Clean and spacious litter box with odor control.',
            imageUrl:
                'https://images.pexels.com/photos/695644/pexels-photo-695644.jpeg?auto=compress&cs=tinysrgb&w=1200',
            animalType: 'Cat',
          ),
          const Product(
            id: '5',
            name: 'Dog Training Treats',
            category: 'Food',
            price: 14.20,
            description: 'Soft reward treats for daily training sessions.',
            imageUrl:
                'https://images.pexels.com/photos/7210269/pexels-photo-7210269.jpeg?auto=compress&cs=tinysrgb&w=1200',
            animalType: 'Dog',
          ),
          const Product(
            id: '6',
            name: 'Rabbit Hay Bundle',
            category: 'Food',
            price: 22.40,
            description: 'Fresh fiber-rich hay for rabbits and guinea pigs.',
            imageUrl:
                'https://images.pexels.com/photos/326012/pexels-photo-326012.jpeg?auto=compress&cs=tinysrgb&w=1200',
            animalType: 'Rabbit',
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
        if (event.animalType != null && event.animalType != 'All') {
          mockProducts = mockProducts
              .where((p) => p.animalType == event.animalType)
              .toList();
        }

        emit(ShopLoaded(mockProducts));
      } catch (e) {
        emit(const ShopError('Failed to fetch products'));
      }
    });
  }
}
