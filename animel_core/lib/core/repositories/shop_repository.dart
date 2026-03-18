import '../models/product_model.dart';
import '../services/api_client.dart';

class ShopRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> getProducts({String? query, String? category}) async {
    try {
      final response = await _apiClient.dio.get('/shop/products', queryParameters: {
        if (query != null) 'query': query,
        if (category != null && category != 'All') 'category': category,
      });

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Product.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Product?> getProductDetails(String id) async {
    try {
      final response = await _apiClient.dio.get('/shop/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
