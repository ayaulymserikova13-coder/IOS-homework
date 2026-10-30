
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool isGrid = false;
  int nextId = 11;

  List<Product> products = [];

  List<Product> initialProducts() {
    return [
      Product(id: 1, title: 'Lavender Cardigan', category: 'Knitwear', price: 18900, rating: 4.9),
      Product(id: 2, title: 'Floral Dress', category: 'Dresses', price: 24900, rating: 4.8),
      Product(id: 3, title: 'Straight Jeans', category: 'Denim', price: 21900, rating: 4.7),
      Product(id: 4, title: 'Satin Blouse', category: 'Tops', price: 15900, rating: 4.8),
      Product(id: 5, title: 'Classic Trench Coat', category: 'Outerwear', price: 39900, rating: 4.9),
      Product(id: 6, title: 'Cotton T-Shirt', category: 'Basics', price: 7900, rating: 4.6),
      Product(id: 7, title: 'Pleated Skirt', category: 'Skirts', price: 13900, rating: 4.7),
      Product(id: 8, title: 'Cozy Sweater', category: 'Knitwear', price: 17900, rating: 4.9),
      Product(id: 9, title: 'Wide Leg Pants', category: 'Pants', price: 19900, rating: 4.8),
      Product(id: 10, title: 'Casual Hoodie', category: 'Hoodies', price: 14900, rating: 4.7),
    ];
  }

  @override
  void initState() {
    super.initState();
    products = initialProducts();
  }

  void resetCatalog() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    setState(() {
      products = initialProducts();
      nextId = 11;
    });
  }

  Future<void> refreshCatalog() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    if (!mounted) return;

    setState(() {
      products.insert(
        0,
        Product(
          id: nextId,
          title: 'New Arrival $nextId',
          category: 'New Collection',
          price: 12900,
          rating: 4.9,
        ),
      );
      nextId++;
    });
  }

  void deleteProduct(Product product) {
    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) return;

    setState(() {
      products.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF79559D),
        content: Text('${product.title} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            if (products.any((item) => item.id == product.id)) {
              return;
            }

            setState(() {
              final restoreIndex =
                  index > products.length
                      ? products.length
                      : index;

              products.insert(restoreIndex, product);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7FC),
        title: const Text(
          'Lilac Closet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4C3764),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Switch view',
            icon: Icon(
              isGrid ? Icons.view_list : Icons.grid_view,
              color: const Color(0xFF79559D),
            ),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 72,
                    color: Color(0xFFB69BD3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Catalog is Empty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: resetCatalog,
                    child: const Text('Reset Catalog'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF79559D),
              onRefresh: refreshCatalog,
              child: isGrid
                  ? GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: products[index],
                        );
                      },
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: products.length,
                      separatorBuilder: (context, index) =>
                          const Divider(
                        height: 1,
                        color: Color(0xFFE9DDF1),
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Dismissible(
                          key: ValueKey(product.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            deleteProduct(product);
                          },
                          child: ProductTile(product: product),
                        );
                      },
                    ),
            ),
    );
  }
}
