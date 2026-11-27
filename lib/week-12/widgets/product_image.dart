import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      semanticLabel: product.title,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _placeholder(),
      errorBuilder: (context, error, stack) => _placeholder(),
    ),
  );
  Widget _placeholder() => ColoredBox(
    color: const Color(0xFFEEF0FF),
    child: Center(
      child: Icon(
        switch (product.category) {
          'Smartphones' => Icons.smartphone_rounded,
          'Wearables' => Icons.watch_outlined,
          'Tablets' => Icons.tablet_mac_rounded,
          'Speakers' => Icons.speaker_rounded,
          'Accessories' => Icons.mouse_outlined,
          _ => Icons.headphones_rounded,
        },
        size: 48,
        color: const Color(0xFF4F46E5),
      ),
    ),
  );
}
