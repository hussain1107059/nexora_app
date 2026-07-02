class Payment {
  final String transId;
  final DateTime date;
  final String transactionType;
  final String paymentType;
  final String bankName;
  final String type;
  final String selectName;
  final double amount;
  final String description;

  const Payment({
    required this.transId,
    required this.date,
    required this.transactionType,
    required this.paymentType,
    required this.bankName,
    required this.type,
    required this.selectName,
    required this.amount,
    required this.description,
  });
}
