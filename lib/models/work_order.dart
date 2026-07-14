class WorkOrderItem {
  final String productName;
  final double quantity;

  const WorkOrderItem({
    required this.productName,
    required this.quantity,
  });
}

class WorkOrder {
  final DateTime date;
  final String workType;
  final String organization;
  final String remarks;
  final List<WorkOrderItem> items;

  const WorkOrder({
    required this.date,
    required this.workType,
    required this.organization,
    required this.remarks,
    required this.items,
  });

  double get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}
