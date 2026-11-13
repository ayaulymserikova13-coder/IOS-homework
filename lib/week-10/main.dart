import 'dart:ui';

import 'package:flutter/material.dart';

import 'screens/product_list_screen.dart';

void main() => runApp(const CloudStoreApp());

class CloudStoreApp extends StatelessWidget {
  const CloudStoreApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cloud Store',
    debugShowCheckedModeBanner: false,
    scrollBehavior: const MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      },
    ),
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7461A8)),
      scaffoldBackgroundColor: const Color(0xFFF8F6FC),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF8F6FC)),
    ),
    home: const ProductListScreen(),
  );
}
