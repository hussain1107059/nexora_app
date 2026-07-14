class ExpenditureItem {
  final String itemName;
  final double saleRate;
  final double quantity;

  const ExpenditureItem({
    required this.itemName,
    required this.saleRate,
    required this.quantity,
  });

  double get total => saleRate * quantity;
}

class Expenditure {
  final DateTime date;
  final String type;
  final String paymentType;
  final String? bankName;
  final String sellerName;
  final String description;
  final List<ExpenditureItem> items;

  const Expenditure({
    required this.date,
    required this.type,
    required this.paymentType,
    this.bankName,
    required this.sellerName,
    required this.description,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}
