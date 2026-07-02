class HatcheryIncomeItem {
  String type;
  String productName;
  double unitPrice;
  int quantity;

  HatcheryIncomeItem({
    required this.type,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  double get total => unitPrice * quantity;
}

class HatcheryIncome {
  final DateTime date;
  final String buyerName;
  final String buyerAddress;
  final String remarks;
  final List<HatcheryIncomeItem> items;

  HatcheryIncome({
    required this.date,
    required this.buyerName,
    required this.buyerAddress,
    required this.remarks,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}
