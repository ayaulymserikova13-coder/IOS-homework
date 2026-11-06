import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  bool contains(Product product) => _items.any((item) => item.id == product.id);

  void toggleItem(Product product) {
    if (contains(product)) {
      removeItem(product);
    } else {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    if (!contains(product)) return;
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clearAll() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
