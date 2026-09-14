double processOrder({
  required int orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  double delivery=deliveryFee ?? 500.0;

  if (promoCode=='SAVE10') {
    itemPrice=itemPrice*0.9;
  }

  double total=itemPrice+delivery;
  print('Order ID: $orderId');
  print('Item price: $itemPrice');
  print('Delivery fee: $delivery');
  print('Final total: $total');
  return total;
}
void main() {
  processOrder(
    orderId: 101,
    itemPrice: 10000.0,
    promoCode: 'SAVE10',
  );
}