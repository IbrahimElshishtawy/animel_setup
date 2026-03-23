import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/api_exception.dart';
import '../services/api_client.dart';

class ShopRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> getProducts({String? query, String? category}) async {
    try {
      final response = await _apiClient.dio.get(
        '/shop/products',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'query': query,
          if (category != null && category != 'All') 'category': category,
        },
      );

      return (response.data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Product> getProductDetails(String id) async {
    try {
      final response = await _apiClient.dio.get('/shop/products/$id');
      return Product.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/shop/categories');
      return (response.data as List<dynamic>).map((e) => e.toString()).toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Cart> getCart() async {
    try {
      final response = await _apiClient.dio.get('/shop/cart');
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Cart> addToCart(String productId, {int quantity = 1}) async {
    try {
      final response = await _apiClient.dio.post(
        '/shop/cart/items',
        data: {'productId': productId, 'quantity': quantity},
      );
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Cart> updateCartItem(String productId, int quantity) async {
    try {
      final response = await _apiClient.dio.put(
        '/shop/cart/items/$productId',
        data: {'quantity': quantity},
      );
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Cart> removeCartItem(String productId) async {
    try {
      final response = await _apiClient.dio.delete('/shop/cart/items/$productId');
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
