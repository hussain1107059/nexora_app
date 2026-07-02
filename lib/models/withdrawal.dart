class Withdrawal {
  final String person;
  final String paymentType;
  final String? bankName;
  final DateTime date;
  final double amount;
  final String reason;
  final String comment;

  const Withdrawal({
    required this.person,
    required this.paymentType,
    this.bankName,
    required this.date,
    required this.amount,
    required this.reason,
    required this.comment,
  });
}
