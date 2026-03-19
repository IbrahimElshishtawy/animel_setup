import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/repositories/shop_repository.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ShopEvent {
  final String? query;
  final String? category;

  const FetchProducts({this.query, this.category});

  @override
  List<Object?> get props => [query, category];
}

class FetchCategories extends ShopEvent {}

class FetchCart extends ShopEvent {}

class AddToCartRequested extends ShopEvent {
  final String productId;
  final int quantity;

  const AddToCartRequested(this.productId, {this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartItemRequested extends ShopEvent {
  final String productId;
  final int quantity;

  const UpdateCartItemRequested(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveCartItemRequested extends ShopEvent {
  final String productId;

  const RemoveCartItemRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearShopMessage extends ShopEvent {}

class ShopState extends Equatable {
  final List<Product> products;
  final List<String> categories;
  final Cart cart;
  final bool isLoading;
  final bool isCartLoading;
  final String? errorMessage;
  final String? successMessage;

  const ShopState({
    this.products = const [],
    this.categories = const ['All'],
    this.cart = const Cart.empty(),
    this.isLoading = false,
    this.isCartLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  const ShopState.initial() : this();

  ShopState copyWith({
    List<Product>? products,
    List<String>? categories,
    Cart? cart,
    bool? isLoading,
    bool? isCartLoading,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ShopState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      isCartLoading: isCartLoading ?? this.isCartLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        cart,
        isLoading,
        isCartLoading,
        errorMessage,
        successMessage,
      ];
}

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _repository = ShopRepository();

  ShopBloc() : super(const ShopState.initial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchCategories>(_onFetchCategories);
    on<FetchCart>(_onFetchCart);
    on<AddToCartRequested>(_onAddToCartRequested);
    on<UpdateCartItemRequested>(_onUpdateCartItemRequested);
    on<RemoveCartItemRequested>(_onRemoveCartItemRequested);
    on<ClearShopMessage>(
      (event, emit) => emit(state.copyWith(clearError: true, clearSuccess: true)),
    );
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final products = await _repository.getProducts(
        query: event.query,
        category: event.category,
      );
      emit(state.copyWith(products: products, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<ShopState> emit,
  ) async {
    try {
      final categories = await _repository.getCategories();
      final resolvedCategories = [
        'All',
        ...categories.where((category) => category != 'All'),
      ];
      emit(state.copyWith(categories: resolvedCategories));
    } catch (_) {
      // Keep default categories if category endpoint fails.
    }
  }

  Future<void> _onFetchCart(FetchCart event, Emitter<ShopState> emit) async {
    emit(state.copyWith(isCartLoading: true, clearError: true, clearSuccess: true));
    try {
      final cart = await _repository.getCart();
      emit(state.copyWith(cart: cart, isCartLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isCartLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onAddToCartRequested(
    AddToCartRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(isCartLoading: true, clearError: true, clearSuccess: true));
    try {
      final cart = await _repository.addToCart(
        event.productId,
        quantity: event.quantity,
      );
      emit(
        state.copyWith(
          cart: cart,
          isCartLoading: false,
          successMessage: 'Product added to cart',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isCartLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onUpdateCartItemRequested(
    UpdateCartItemRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(isCartLoading: true, clearError: true, clearSuccess: true));
    try {
      final cart = await _repository.updateCartItem(event.productId, event.quantity);
      emit(state.copyWith(cart: cart, isCartLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isCartLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onRemoveCartItemRequested(
    RemoveCartItemRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(isCartLoading: true, clearError: true, clearSuccess: true));
    try {
      final cart = await _repository.removeCartItem(event.productId);
      emit(state.copyWith(cart: cart, isCartLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isCartLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }
}
