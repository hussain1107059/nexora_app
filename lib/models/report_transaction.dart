class ReportTransaction {
  final String date;
  final String? invoice;
  final String organization;
  final double amount;

  const ReportTransaction({
    required this.date,
    this.invoice,
    required this.organization,
    required this.amount,
  });
}
