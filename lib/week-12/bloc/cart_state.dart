import 'package:equatable/equatable.dart';

import '../models/product.dart';

class CartState extends Equatable {
  CartState({List<Product> items = const []})
    : items = List.unmodifiable(items);
  final List<Product> items;
  // Derived values cannot drift out of sync with the immutable item list.
  int get count => items.length;
  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.price);
  @override
  List<Object> get props => [items];
}
