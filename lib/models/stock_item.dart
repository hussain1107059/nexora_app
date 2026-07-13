class WarehouseStock {
  final String warehouse;
  final double quantityBag;
  final double quantityMon;
  final double quantityKg;

  const WarehouseStock({
    required this.warehouse,
    required this.quantityBag,
    required this.quantityMon,
    required this.quantityKg,
  });
}

class StockItem {
  final String productName;
  final double quantityBag;
  final double quantityMon;
  final double quantityKg;
  final List<WarehouseStock> warehouses;

  const StockItem({
    required this.productName,
    required this.quantityBag,
    required this.quantityMon,
    required this.quantityKg,
    required this.warehouses,
  });
}
