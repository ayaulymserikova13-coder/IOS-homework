import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
  });
}

final List<Product> products = [
  Product(
    title: 'Soft Knit Cardigan',
    description: 'A soft and comfortable cardigan for everyday outfits.',
    image: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=600',
    price: 12990,
    category: 'Knitwear',
  ),
  Product(
    title: 'Classic White Shirt',
    description: 'An elegant white shirt for a simple and stylish look.',
    image: 'https://images.unsplash.com/photo-1598032895397-b9472444bf93?w=600',
    price: 9990,
    category: 'Shirts',
  ),
  Product(
    title: 'Casual Denim Jeans',
    description: 'Comfortable denim jeans for your daily wardrobe.',
    image: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600',
    price: 15990,
    category: 'Jeans',
  ),
  Product(
    title: 'Summer Dress',
    description: 'A light and beautiful dress for warm sunny days.',
    image: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=600',
    price: 18990,
    category: 'Dresses',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luna Store',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9575CD),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F7FC),
          foregroundColor: Color(0xFF493B61),
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final List<Product> favorites = [];

  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }
    });
  }

  void openDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          product: product,
          isFavorite: favorites.contains(product),
          onFavorite: () => toggleFavorite(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildFeed(),
      buildFavorites(),
      buildProfile(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LUNA STORE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF9575CD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildFeed() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Discover your style',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF493B61),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your everyday fashion favorites',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        ...products.map((product) => buildProductCard(product)),
      ],
    );
  }

  Widget buildProductCard(Product product) {
    final isSaved = favorites.contains(product);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => openDetails(product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: 105,
                  height: 115,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 105,
                      height: 115,
                      color: const Color(0xFFEDE7F6),
                      child: const Icon(Icons.checkroom),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category,
                      style: const TextStyle(
                        color: Color(0xFF9575CD),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${product.price.toStringAsFixed(0)} ₸',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7956B1),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFF9575CD),
                ),
                onPressed: () => toggleFavorite(product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFavorites() {
    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 65,
              color: Color(0xFFB39DDB),
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Save the items you love!'),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: favorites
          .map((product) => buildProductCard(product))
          .toList(),
    );
  }

  Widget buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFE6D9F5),
            child: Icon(
              Icons.person,
              size: 50,
              color: Color(0xFF9575CD),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Luna Member',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Welcome to your profile',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Saved items'),
              trailing: Text('${favorites.length}'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const DetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              product.image,
              height: 290,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 290,
                  color: const Color(0xFFEDE7F6),
                  child: const Icon(Icons.checkroom, size: 70),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            product.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF9575CD),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF493B61),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${product.price.toStringAsFixed(0)} ₸',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7956B1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              widget.onFavorite();
              setState(() {
                isSaved = !isSaved;
              });
            },
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
            ),
            label: Text(
              isSaved ? 'Remove from Favorites' : 'Add to Favorites',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6D9F5),
              foregroundColor: const Color(0xFF493B61),
              padding: const EdgeInsets.all(15),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Feed'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7956B1),
              padding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }
}
