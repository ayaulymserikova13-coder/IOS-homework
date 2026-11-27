import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddProductEvent>((event, emit) {
      emit(CartState(items: [...state.items, event.product]));
    });
    on<RemoveProductEvent>((event, emit) {
      final index = state.items.indexWhere(
        (item) => item.id == event.productId,
      );
      if (index == -1) return;
      // Copy first: remove only one unit and preserve every previous snapshot.
      final items = [...state.items]..removeAt(index);
      emit(CartState(items: items));
    });
    on<ClearCartEvent>((event, emit) => emit(CartState()));
  }
}
