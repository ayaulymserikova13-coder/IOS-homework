import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            product.imageUrl,
            width: 52,
            height: 56,
            fit: BoxFit.contain,
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              width: 52,
              height: 56,
              child: Icon(Icons.checkroom, color: Color(0xFF906CB1)),
            ),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1E9F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.category,
                style: const TextStyle(fontSize: 12, color: Color(0xFF79559D)),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFD5A044), size: 17),
                const SizedBox(width: 4),
                Text('${product.rating}'),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    '${product.price.toStringAsFixed(0)} ₸',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF79559D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
