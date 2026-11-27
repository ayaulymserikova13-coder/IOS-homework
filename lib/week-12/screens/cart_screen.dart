import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<CartBloc, CartState>(
    builder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            onPressed: state.count == 0
                ? null
                : () => context.read<CartBloc>().add(const ClearCartEvent()),
            child: const Text('Clear All'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: state.count == 0
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEEF0FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Your cart is empty.',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Add something you love.'),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Continue shopping'),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        '${state.count} ${state.count == 1 ? 'item' : 'items'}',
                        style: const TextStyle(color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 16),
                      for (final product in state.items)
                        Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 64,
                                  height: 76,
                                  child: ProductImage(product: product),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(formatPrice(product.price)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Remove ${product.title}',
                                  color: const Color(0xFFDC2626),
                                  onPressed: () => context.read<CartBloc>().add(
                                    RemoveProductEvent(product.id),
                                  ),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Card(
                        margin: EdgeInsets.zero,
                        color: const Color(0xFFEEEDFC),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _summaryRow('Items', '${state.count}'),
                              const SizedBox(height: 12),
                              _summaryRow(
                                'Subtotal',
                                formatPrice(state.totalPrice),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(),
                              ),
                              _summaryRow(
                                'Total',
                                formatPrice(state.totalPrice),
                                bold: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );

  Widget _summaryRow(String label, String value, {bool bold = false}) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 16,
    runSpacing: 8,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: bold ? 22 : 14,
          color: bold ? const Color(0xFF4F46E5) : const Color(0xFF111827),
        ),
      ),
    ],
  );
}
