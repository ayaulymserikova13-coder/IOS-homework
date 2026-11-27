import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../models/product.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ProductImage(product: product)),
          const SizedBox(height: 12),
          Text(
            product.category,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            product.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            formatPrice(product.price),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () =>
                context.read<CartBloc>().add(AddProductEvent(product)),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEEEDFC),
              foregroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}
