
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE9DDF1),
        ),
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
              child: const Icon(
                Icons.checkroom,
                size: 48,
                color: Color(0xFF906CB1),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.category,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF906CB1),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFD5A044),
                size: 16,
              ),
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
        ],
      ),
    );
  }
}
