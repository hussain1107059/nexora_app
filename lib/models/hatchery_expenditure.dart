class HatcheryExpenditure {
  final String expenditureType;
  final DateTime date;
  final String vendorName;
  final String vendorAddress;
  final double amount;
  final String remarks;

  const HatcheryExpenditure({
    required this.expenditureType,
    required this.date,
    required this.vendorName,
    required this.vendorAddress,
    required this.amount,
    required this.remarks,
  });
}
