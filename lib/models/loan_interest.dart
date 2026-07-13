class LoanEntry {
  final String date;
  final double allocation;
  final double repayment;
  final double balance;
  final double interest;

  const LoanEntry({
    required this.date,
    required this.allocation,
    required this.repayment,
    required this.balance,
    required this.interest,
  });
}

class LoanAccount {
  final String loanNo;
  final String bank;
  final List<LoanEntry> entries;

  const LoanAccount({
    required this.loanNo,
    required this.bank,
    required this.entries,
  });
}
