class ErpModule {
  final String title;
  final String icon;
  final String description;

  const ErpModule({
    required this.title,
    required this.icon,
    required this.description,
  });
}

final List<ErpModule> erpModules = [
  const ErpModule(title: 'Account', icon: 'account_balance', description: 'Ledger, invoices, payments'),
  const ErpModule(title: 'Administration', icon: 'admin_panel_settings', description: 'Users, approvals, policies'),
  const ErpModule(title: 'Product', icon: 'inventory', description: 'Product catalog, variants, pricing'),
  const ErpModule(title: 'Supply', icon: 'local_shipping', description: 'Suppliers, stock, logistics'),
  const ErpModule(title: 'Manufacture', icon: 'precision_manufacturing', description: 'Production, BOM, work orders'),
  const ErpModule(title: 'Sale', icon: 'shopping_cart', description: 'Orders, quotations, deliveries'),
  const ErpModule(title: 'Work Order', icon: 'build_circle', description: 'Tasks, maintenance, operations'),
  const ErpModule(title: 'Expenditure', icon: 'receipt', description: 'Expense tracking, cost analysis, budgets'),
  const ErpModule(title: 'Sale Return', icon: 'assignment_return', description: 'Returns, refunds, credit notes'),
  const ErpModule(title: 'Inventory Loss', icon: 'report_problem', description: 'Wastage, damage, stock adjustments'),
  const ErpModule(title: 'Report', icon: 'analytics', description: 'Analytics, profit, performance'),
  const ErpModule(title: 'Stock', icon: 'inventory_2', description: 'Stock levels, warehouses, and item tracking'),
];
