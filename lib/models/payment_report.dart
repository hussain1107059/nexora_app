class PaymentReport {
  final String date;
  final String transId;
  final String organization;
  final String type;
  final double amount;

  const PaymentReport({
    required this.date,
    required this.transId,
    required this.organization,
    required this.type,
    required this.amount,
  });
}
