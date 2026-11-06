import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final added = context.watch<CartProvider>().contains(product);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9DDF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEEE3F5),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.checkroom,
                  size: 48,
                  color: Color(0xFF906CB1),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.category,
            style: const TextStyle(fontSize: 12, color: Color(0xFF906CB1)),
          ),

          const SizedBox(height: 6),

          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFD5A044), size: 16),
              const SizedBox(width: 4),
              Text('${product.rating}'),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '${product.price.toStringAsFixed(0)} ₸',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF79559D),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: ValueKey('toggle-${product.id}'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: added
                    ? const Color(0xFFE9DDF1)
                    : const Color(0xFF79559D),
                foregroundColor: added ? const Color(0xFF4C3764) : Colors.white,
              ),
              onPressed: () => context.read<CartProvider>().toggleItem(product),
              child: Text(added ? 'Added ✓' : 'Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
