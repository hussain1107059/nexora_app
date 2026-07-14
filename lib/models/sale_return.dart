import 'sale.dart';

class SaleReturnItem {
  final String productName;
  final double unitPrice;
  final double quantity;
  final String warehouse;

  const SaleReturnItem({
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.warehouse,
  });

  double get total => unitPrice * quantity;
}

class SaleReturn {
  final DateTime date;
  final String invoiceNo;
  final String organization;
  final String reason;
  final List<SaleReturnItem> items;

  const SaleReturn({
    required this.date,
    required this.invoiceNo,
    required this.organization,
    required this.reason,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}

final List<Sale> _sampleSales = [
  Sale(
    date: DateTime(2026, 7, 10),
    saleType: 'Whole Sale',
    customer: 'Green Agro',
    chalanNo: 'CH-001',
    partyNo: 'PT-101',
    serialNo: 'SR-001',
    truck: 'Truck A (DA-1234)',
    remarks: 'Bulk rice order',
    items: [
      const SaleItem(productName: 'Rice BR-28', saleRate: 55, warehouse: 'Main Warehouse', packageWeight: 50, quantity: 100),
    ],
  ),
  Sale(
    date: DateTime(2026, 7, 15),
    saleType: 'Retail',
    customer: 'Rahim Store',
    chalanNo: 'CH-002',
    partyNo: 'PT-102',
    serialNo: 'SR-002',
    truck: 'Truck B (DA-5678)',
    remarks: 'Mixed items',
    items: [
      const SaleItem(productName: 'Wheat', saleRate: 40, warehouse: 'Main Warehouse', packageWeight: 50, quantity: 50),
      const SaleItem(productName: 'Maize', saleRate: 35, warehouse: 'North Storage', packageWeight: 25, quantity: 30),
    ],
  ),
  Sale(
    date: DateTime(2026, 7, 20),
    saleType: 'Whole Sale',
    customer: 'Hasan Enterprise',
    chalanNo: 'CH-003',
    partyNo: 'PT-103',
    serialNo: '482326',
    truck: 'Truck C (DA-9012)',
    remarks: 'Fertilizer order',
    items: [
      const SaleItem(productName: 'DAP Fertilizer', saleRate: 120, warehouse: 'Main Warehouse', packageWeight: 50, quantity: 200),
      const SaleItem(productName: 'Urea', saleRate: 85, warehouse: 'North Storage', packageWeight: 50, quantity: 150),
      const SaleItem(productName: 'TSP', saleRate: 95, warehouse: 'East Storage', packageWeight: 50, quantity: 100),
    ],
  ),
];

Sale? findSaleByInvoice(String invoiceNo) {
  try {
    return _sampleSales.firstWhere((s) => s.serialNo == invoiceNo);
  } catch (_) {
    return null;
  }
}

List<String> get allInvoiceNumbers => _sampleSales.map((s) => s.serialNo).toList();
