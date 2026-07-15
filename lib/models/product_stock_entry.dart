class StockEntryItem {
  final String productCategory;
  final double productQuantity;
  final double productCosting;
  final String warehouse;

  const StockEntryItem({
    required this.productCategory,
    required this.productQuantity,
    required this.productCosting,
    required this.warehouse,
  });
}

class ProductStockEntry {
  final DateTime date;
  final String productionChalan;
  final double manufactureCost;
  final double generalCost;
  final String remarks;
  final List<StockEntryItem> items;

  const ProductStockEntry({
    required this.date,
    required this.productionChalan,
    required this.manufactureCost,
    required this.generalCost,
    required this.remarks,
    required this.items,
  });

  double get totalQuantity => items.fold(0, (sum, item) => sum + item.productQuantity);
  double get totalCost => items.fold(0, (sum, item) => sum + item.productCosting);
}
