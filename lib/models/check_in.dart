class CheckInPunch {
  final DateTime time;
  final double latitude;
  final double longitude;
  final String address;
  final String description;
  final double amount;

  const CheckInPunch({
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.description = '',
    this.amount = 0,
  });

  CheckInPunch copyWith({String? description, double? amount}) {
    return CheckInPunch(
      time: time,
      latitude: latitude,
      longitude: longitude,
      address: address,
      description: description ?? this.description,
      amount: amount ?? this.amount,
    );
  }
}

class CheckInSession {
  final DateTime date;
  final String title;
  final String remarks;
  final List<CheckInPunch> punches;

  const CheckInSession({
    required this.date,
    required this.title,
    required this.remarks,
    required this.punches,
  });

  int get totalPunches => punches.length;
  double get totalExpenses => punches.fold(0, (sum, p) => sum + p.amount);
}
