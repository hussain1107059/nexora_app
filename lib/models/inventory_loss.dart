class InventoryLossItem {
  final String productName;
  final String warehouse;
  final double quantity;
  final double unitPrice;

  const InventoryLossItem({
    required this.productName,
    required this.warehouse,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;
}

class InventoryLoss {
  final DateTime date;
  final String reason;
  final List<InventoryLossItem> items;

  const InventoryLoss({
    required this.date,
    required this.reason,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
}
