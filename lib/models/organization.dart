class OrgTransaction {
  final String date;
  final String type;
  final double total;
  final double paid;
  final double due;

  const OrgTransaction({
    required this.date,
    required this.type,
    required this.total,
    required this.paid,
    required this.due,
  });
}

class Organization {
  final String name;
  final String owner;
  final String phone;
  final double balance;
  final List<OrgTransaction> transactions;

  const Organization({
    required this.name,
    required this.owner,
    required this.phone,
    required this.balance,
    required this.transactions,
  });
}
