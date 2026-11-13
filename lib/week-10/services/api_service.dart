import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('https://fakestoreapi.com/products'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! List) throw const FormatException();
        return data.map((item) {
          if (item is! Map<String, dynamic>) throw const FormatException();
          return Product.fromJson(item);
        }).toList();
      }
      if (response.statusCode == 404) {
        throw const ApiException(
          'Product feed not found (404). Please try again later.',
        );
      }
      if (response.statusCode >= 500) {
        throw ApiException(
          'The store server is unavailable (${response.statusCode}). Please retry.',
        );
      }
      throw ApiException(
        'Request failed (${response.statusCode}). Please retry.',
      );
    } on TimeoutException {
      throw const ApiException(
        'The request timed out after 10 seconds. Check your connection and retry.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Cannot reach the store. Check your internet connection and retry.',
      );
    } on FormatException {
      throw const ApiException(
        'The store returned invalid data. Please try again later.',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Unable to load products. Please try again.');
    }
  }
}
