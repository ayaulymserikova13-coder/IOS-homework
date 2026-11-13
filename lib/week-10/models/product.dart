class Product {
  final int id;
  final String title, description, category, imageUrl;
  final double price, rating;
  final int reviewCount;
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratings = json['rating'] is Map ? json['rating'] as Map : const {};
    String text(dynamic value, String fallback) =>
        value is String && value.isNotEmpty ? value : fallback;
    return Product(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      title: text(json['title'], 'Untitled product'),
      // JSON numbers can be int OR double.
      price: json['price'] is num ? (json['price'] as num).toDouble() : 0.0,
      description: text(json['description'], 'No description available.'),
      category: text(json['category'], 'Other'),
      imageUrl: text(json['image'], ''),
      rating: ratings['rate'] is num
          ? (ratings['rate'] as num).toDouble()
          : 0.0,
      reviewCount: ratings['count'] is num
          ? (ratings['count'] as num).toInt()
          : 0,
    );
  }
}
