import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Above MaterialApp so both routes share the same cart.
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lilac Closet',
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF906CB1)),
          scaffoldBackgroundColor: const Color(0xFFFAF7FC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFAF7FC),
            foregroundColor: Color(0xFF4C3764),
            titleTextStyle: TextStyle(
              color: Color(0xFF4C3764),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}
