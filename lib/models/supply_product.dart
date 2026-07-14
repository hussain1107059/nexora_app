class SupplyProductItem {
  final String productName;
  final double buyRate;
  final int numberOfBags;
  final double quantityKg;
  final double weightPerBagMon;
  final String warehouse;

  const SupplyProductItem({
    required this.productName,
    required this.buyRate,
    required this.numberOfBags,
    required this.quantityKg,
    required this.weightPerBagMon,
    required this.warehouse,
  });

  double get total => buyRate * quantityKg;
}

class SupplyProduct {
  final DateTime chalanDate;
  final String chalanNo;
  final String partyNo;
  final String serialNo;
  final String supplier;
  final String truckNumber;
  final String remarks;
  final List<SupplyProductItem> items;

  const SupplyProduct({
    required this.chalanDate,
    required this.chalanNo,
    required this.partyNo,
    required this.serialNo,
    required this.supplier,
    required this.truckNumber,
    required this.remarks,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}
