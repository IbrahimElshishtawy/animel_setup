import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_copy.dart';
import '../../../core/models/product_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../logic/shop_bloc.dart';

part '../widgets/product_detail_sections.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;

    return BlocListener<ShopBloc, ShopState>(
      listenWhen: (previous, current) =>
          previous.successMessage != current.successMessage ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.successMessage;
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        context.read<ShopBloc>().add(ClearShopMessage());
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            ProductDetailAppBar(imageUrl: product.imageUrl),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductSummarySection(product: product),
                    const SizedBox(height: 18),
                    ProductDescriptionSection(
                      title: copy.description,
                      description: product.description.isEmpty
                          ? copy.productDescriptionEmpty
                          : product.description,
                      stockLabel: copy.stock,
                      stockValue: '${product.stock}',
                      typeLabel: copy.type,
                      typeValue: product.animalType.isEmpty
                          ? copy.general
                          : product.animalType,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<ShopBloc>().add(
                            AddToCartRequested(product.id),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_checkout_rounded),
                        label: Text(copy.addToCart),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
