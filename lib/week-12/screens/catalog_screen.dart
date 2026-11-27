import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../data/sample_products.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final name = auth is AuthSuccess ? auth.username : 'Student';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TechStore',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: const [CartBadge(), SizedBox(width: 16)],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover your next upgrade.',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF20203E), Color(0xFF4C438E)],
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THE EVERYDAY EDIT',
                          style: TextStyle(
                            color: Color(0xFFBEB9F9),
                            fontSize: 11,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Small upgrades.\nBig possibilities.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            letterSpacing: -0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Everyday essentials, thoughtfully selected.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Featured products',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 900
                          ? 4
                          : constraints.maxWidth >= 650
                          ? 3
                          : 2;
                      final scale =
                          MediaQuery.textScalerOf(context).scale(14) / 14;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sampleProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisExtent: 350 + (scale - 1).clamp(0, 3) * 180,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) =>
                            ProductCard(product: sampleProducts[index]),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
