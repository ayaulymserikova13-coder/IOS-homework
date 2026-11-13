import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final ApiService? api;
  const ProductListScreen({super.key, this.api});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ApiService _api = widget.api ?? ApiService();
  List<Product> _products = [];
  bool _loading = true, _fetching = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts({bool refresh = false}) async {
    if (_fetching) return;
    _fetching = true;
    setState(() {
      _loading = !refresh;
      _error = null;
    });
    try {
      final products = await _api.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
      });
    } finally {
      _fetching = false;
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Cloud Store'),
      actions: [
        IconButton(
          tooltip: 'Refresh products',
          onPressed: _fetching ? null : () => _fetchProducts(),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: _body(),
      ),
    ),
  );

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: Color(0xFF7461A8),
              ),
              const SizedBox(height: 20),
              Text(
                'Connection interrupted',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _fetchProducts(),
                child: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _fetchProducts(refresh: true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: _products.length + 1,
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Everyday discoveries',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _products.isEmpty
                        ? 'No products yet. Pull down to refresh.'
                        : '${_products.length} finds for you · Pull down to refresh',
                  ),
                ],
              ),
            );
          }
          final product = _products[index - 1];
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Hero(
                      tag: 'product_image_${product.id}',
                      child: SizedBox(
                        width: 80,
                        height: 100,
                        child: ProductImage(url: product.imageUrl),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.category,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7461A8),
                            ),
                          ),
                          Text(
                            '★ ${product.rating.toStringAsFixed(1)} · ${product.reviewCount} reviews',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
