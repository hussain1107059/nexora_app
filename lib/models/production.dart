class ProductionItem {
  final String productName;
  final double numberOfBags;
  final double productQuantity;

  const ProductionItem({
    required this.productName,
    required this.numberOfBags,
    required this.productQuantity,
  });
}

class Production {
  final DateTime date;
  final String chalanNo;
  final String factory;
  final String warehouse;
  final String remarks;
  final List<ProductionItem> items;

  const Production({
    required this.date,
    required this.chalanNo,
    required this.factory,
    required this.warehouse,
    required this.remarks,
    required this.items,
  });

  double get totalBag => items.fold(0, (sum, item) => sum + item.numberOfBags);
}
