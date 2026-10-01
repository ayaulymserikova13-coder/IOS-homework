import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9175B5),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF7FD),
      ),
      home: const ProductScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth < 600 ? 280 : 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOFT Collection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF9175B5),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Фотография и закладка
              SizedBox(
                width: double.infinity,
                height: imageHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=900',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFE9DFF3),
                              child: const Center(
                                child: Text(
                                  'Lavender Sweatshirt',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFF70548F),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: const Color(0xFF70548F),
                          ),
                          onPressed: () {
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Название
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lavender Sweatshirt',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40334F),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              const Text(
                'SOFT Everyday Collection',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF91849F),
                ),
              ),

              const SizedBox(height: 16),

              // Рейтинг и цена в одной строке
              const Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFE7B45A),
                    size: 22,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '4.8',
                    style: TextStyle(
                      color: Color(0xFF40334F),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '18 990 ₸',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF70548F),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Категории автоматически переносятся
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text('Clothing'),
                    backgroundColor: Color(0xFFEDE4F5),
                    side: BorderSide.none,
                  ),
                  Chip(
                    label: Text('Oversized'),
                    backgroundColor: Color(0xFFEDE4F5),
                    side: BorderSide.none,
                  ),
                  Chip(
                    label: Text('Casual'),
                    backgroundColor: Color(0xFFEDE4F5),
                    side: BorderSide.none,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF40334F),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'A soft lavender sweatshirt with a relaxed fit. '
                'Comfortable for university, walks and everyday wear. '
                'Easy to match with jeans or your favourite trousers.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF756780),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Product details',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF40334F),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                '• Colour: Lavender\n'
                '• Material: Cotton blend\n'
                '• Fit: Oversized\n'
                '• Sizes: S, M, L',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.8,
                  color: Color(0xFF756780),
                ),
              ),
            ],
          ),
        ),
      ),

      // Кнопка остаётся внизу при прокрутке
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9175B5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product added to cart!'),
                        backgroundColor: Color(0xFF70548F),
                      ),
                    );
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}