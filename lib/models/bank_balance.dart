class StatementEntry {
  final DateTime date;
  final String name;
  final double debit;
  final double credit;
  final double balance;

  const StatementEntry({
    required this.date,
    required this.name,
    required this.debit,
    required this.credit,
    required this.balance,
  });
}

class BankBalance {
  final String bankName;
  final double balance;
  final List<StatementEntry> statements;

  const BankBalance({
    required this.bankName,
    required this.balance,
    required this.statements,
  });
}
