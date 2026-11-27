import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../screens/cart_screen.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<CartBloc, CartState>(
    builder: (context, state) => IconButton(
      tooltip: 'Open cart (${state.count} items)',
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
      icon: Badge(
        label: Text('${state.count}'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    ),
  );
}
