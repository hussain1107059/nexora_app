class SaleItem {
  final String productName;
  final double saleRate;
  final String warehouse;
  final double packageWeight;
  final double quantity;

  const SaleItem({
    required this.productName,
    required this.saleRate,
    required this.warehouse,
    required this.packageWeight,
    required this.quantity,
  });

  double get total => saleRate * quantity;
}

class Sale {
  final DateTime date;
  final String saleType;
  final String customer;
  final String chalanNo;
  final String partyNo;
  final String serialNo;
  final String truck;
  final String remarks;
  final List<SaleItem> items;

  const Sale({
    required this.date,
    required this.saleType,
    required this.customer,
    required this.chalanNo,
    required this.partyNo,
    required this.serialNo,
    required this.truck,
    required this.remarks,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}
