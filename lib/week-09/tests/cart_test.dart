import 'package:flutter/material.dart';
// Kept with LAB 9; flutter_test is already a project dev_dependency.
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../laboratory.dart';
import '../providers/cart_provider.dart';
import '../screens/catalog_screen.dart';

void main() {
  test('Cart toggles, protects its items, totals and notifies listeners', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    var notifications = 0;
    cart.addListener(() => notifications++);
    final products = CatalogScreen.products;
    expect(products, hasLength(6));
    cart.toggleItem(products[0]);
    cart.toggleItem(products[1]);
    expect(cart.count, 2);
    expect(cart.totalPrice, 43800);
    expect(() => cart.items.clear(), throwsUnsupportedError);
    cart.toggleItem(products[0]);
    expect(cart.count, 1);
    expect(cart.totalPrice, 24900);
    cart.removeItem(products[1]);
    expect(cart.totalPrice, 0);
    cart.toggleItem(products[2]);
    cart.clearAll();
    expect(cart.items, isEmpty);
    expect(cart.totalPrice, 0);
    expect(notifications, 6);
  });

  testWidgets('Cart removal and Clear All sync catalog buttons and badge', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final first = find.byKey(const ValueKey('toggle-1'));
    final second = find.byKey(const ValueKey('toggle-2'));
    await tester.tap(first);
    await tester.pump();
    await tester.tap(first);
    await tester.pump();
    expect(find.text('Added ✓'), findsNothing);
    await tester.tap(first);
    await tester.tap(second);
    await tester.pump();
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('2')),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    expect(find.text('Total Price: 43800 ₸'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove Lavender Cardigan'));
    await tester.pump();
    expect(find.text('Total Price: 24900 ₸'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: first, matching: find.text('Add to Cart')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear All'));
    await tester.pump();
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Total Price: 0 ₸'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Added ✓'), findsNothing);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('0')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(const Size(360, 800));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
