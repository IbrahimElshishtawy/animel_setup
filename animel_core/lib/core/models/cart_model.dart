import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItem extends Equatable {
  final String productId;
  final Product? product;
  final int quantity;
  final double priceSnapshot;
  final double lineTotal;

  const CartItem({
    required this.productId,
    required this.product,
    required this.quantity,
    required this.priceSnapshot,
    required this.lineTotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId']?.toString() ?? '',
      product: json['product'] is Map<String, dynamic>
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      priceSnapshot: (json['priceSnapshot'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['lineTotal'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [productId, product, quantity, priceSnapshot, lineTotal];
}

class Cart extends Equatable {
  final List<CartItem> items;
  final int itemCount;
  final double total;

  const Cart({
    required this.items,
    required this.itemCount,
    required this.total,
  });

  const Cart.empty()
      : items = const [],
        itemCount = 0,
        total = 0;

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CartItem.fromJson)
          .toList(),
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [items, itemCount, total];
}
