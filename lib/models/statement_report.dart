class StatementBreakdown {
  final double sale;
  final double saleReturn;
  final double supplyAmountReceive;
  final double amountPayment;
  final double expenditure;
  final double otherIncome;
  final double withdrawal;
  final double hatcheryIncome;
  final double hatcheryExpense;

  const StatementBreakdown({
    required this.sale,
    required this.saleReturn,
    required this.supplyAmountReceive,
    required this.amountPayment,
    required this.expenditure,
    required this.otherIncome,
    required this.withdrawal,
    required this.hatcheryIncome,
    required this.hatcheryExpense,
  });
}

class StatementReport {
  final String date;
  final double totalIncome;
  final double totalCost;
  final double profitLoss;
  final StatementBreakdown breakdown;

  const StatementReport({
    required this.date,
    required this.totalIncome,
    required this.totalCost,
    required this.profitLoss,
    required this.breakdown,
  });
}
