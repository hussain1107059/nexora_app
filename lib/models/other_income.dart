class OtherIncome {
  final String incomeSource;
  final String consumerName;
  final DateTime date;
  final String paymentMethod;
  final String? bankName;
  final double amount;
  final String remarks;

  const OtherIncome({
    required this.incomeSource,
    required this.consumerName,
    required this.date,
    required this.paymentMethod,
    this.bankName,
    required this.amount,
    required this.remarks,
  });
}
