class BankTransfer {
  final DateTime date;
  final String sourceBank;
  final String destinationBank;
  final double amount;
  final String remarks;

  const BankTransfer({
    required this.date,
    required this.sourceBank,
    required this.destinationBank,
    required this.amount,
    required this.remarks,
  });
}
