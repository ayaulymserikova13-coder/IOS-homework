import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
  final String id, title, category, description, imageUrl;
  final double price;

  @override
  List<Object> get props => [id, title, category, description, price, imageUrl];
}

String formatPrice(double price) {
  final parts = price.toStringAsFixed(2).split('.');
  final whole = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ' ',
  );
  return '$whole${parts.last == '00' ? '' : '.${parts.last}'} ₸';
}
