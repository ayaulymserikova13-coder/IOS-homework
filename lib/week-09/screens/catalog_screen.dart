import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static final List<Product> products = [
    Product(
      id: 1,
      title: 'Lavender Cardigan',
      category: 'Knitwear',
      price: 18900,
      rating: 4.9,
      imageUrl: 'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/422922/item/goods_70_422922.jpg',
    ),
    Product(
      id: 2,
      title: 'Floral Dress',
      category: 'Dresses',
      price: 24900,
      rating: 4.8,
      imageUrl: 'https://xcdn.next.co.uk/common/items/default/default/itemimages/3_4Ratio/product/lge/W68035s5.jpg',
    ),
    Product(
      id: 3,
      title: 'Straight Jeans',
      category: 'Denim',
      price: 21900,
      rating: 4.7,
      imageUrl: 'https://frame-store.com/cdn/shop/files/LMSBT889-WERN-F-V2_jeans-front-packshot-image.jpg?width=600',
    ),
    Product(
      id: 4,
      title: 'Satin Blouse',
      category: 'Tops',
      price: 15900,
      rating: 4.8,
      imageUrl: 'https://osmanbeytextiles.com/images/look-blouses.jpg',
    ),
    Product(
      id: 5,
      title: 'Classic Trench Coat',
      category: 'Outerwear',
      price: 39900,
      rating: 4.9,
      imageUrl: 'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/467151/item/goods_30_467151_3x4.jpg?width=600',
    ),
    Product(
      id: 6,
      title: 'Cotton T-Shirt',
      category: 'Basics',
      price: 7900,
      rating: 4.6,
      imageUrl: 'https://cdn11.bigcommerce.com/s-rxzabllq/images/stencil/1920x1920/products/454/31677/TS20_Aaron_Unisex_Plain_Tshirt_White__73953.1783996956.jpg?c=2&imbypass=on',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lilac Closet'),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const CartScreen()),
            ),
            icon: Badge(
              label: Text('${cart.count}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 390,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: products[index]),
          ),
        ),
      ),
    );
  }
}
