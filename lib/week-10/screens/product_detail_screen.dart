import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductImage extends StatelessWidget {
  final String url;
  const ProductImage({super.key, required this.url});
  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: BoxFit.contain,
    loadingBuilder: (_, child, progress) => progress == null
        ? child
        : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    errorBuilder: (_, error, stack) =>
        const Center(child: Icon(Icons.image_not_supported_outlined, size: 40)),
  );
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  int _cartQuantity = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _share() {
    final link = 'narxoz://store/product/${widget.product.id}';
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share this find',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SelectableText(link),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copy Link'),
                onPressed: () async {
                  try {
                    await Clipboard.setData(ClipboardData(text: link));
                    if (!sheetContext.mounted || !mounted) return;
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied')),
                    );
                  } catch (_) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not copy. Select the link and copy it manually.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          IconButton(
            tooltip: 'Share',
            onPressed: _share,
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(
                height: 300,
                child: Hero(
                  tag: 'product_image_${product.id}',
                  // FakeStore supplies ONE image. Three demo presentations of the
                  // same photo demonstrate the carousel, not extra API photos.
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    clipBehavior: Clip.antiAlias,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: 3,
                      onPageChanged: (value) => setState(() {
                        _page = value;
                      }),
                      itemBuilder: (_, index) => ColoredBox(
                        color: [
                          Colors.white,
                          const Color(0xFFF0EDF9),
                          const Color(0xFFEAF5F1),
                        ][index],
                        child: Padding(
                          padding: EdgeInsets.all([32.0, 16.0, 48.0][index]),
                          child: ProductImage(url: product.imageUrl),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Previous image',
                    onPressed: _page == 0
                        ? null
                        : () => _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('${_page + 1} / 3'),
                  const SizedBox(width: 12),
                  ...List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.all(3),
                      width: _page == index ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _page == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black12,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next image',
                    onPressed: _page == 2
                        ? null
                        : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const Center(child: Text('One photo · three gallery views')),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(label: Text(product.category)),
              ),
              const SizedBox(height: 12),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '★ ${product.rating.toStringAsFixed(1)} · ${product.reviewCount} reviews',
              ),
              const SizedBox(height: 24),
              Text(
                'About this product',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 802),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(
                    _cartQuantity == 0
                        ? 'Add to Cart'
                        : 'Add to Cart · $_cartQuantity added',
                  ),
                  onPressed: () {
                    setState(() {
                      _cartQuantity++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added to local cart ($_cartQuantity).'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
