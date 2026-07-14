import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/erp_module.dart';
import '../widgets/erp_drawer.dart';
import 'bank_screen.dart';
import 'bank_balance_screen.dart';
import 'bank_transfer_screen.dart';
import 'hatchery_expenditure_screen.dart';
import 'hatchery_income_screen.dart';
import 'other_income_screen.dart';
import 'payment_screen.dart';
import 'product_category_screen.dart';
import 'product_screen.dart';
import 'withdrawal_screen.dart';
import 'stock_list_screen.dart';
import 'report_list_screen.dart';
import 'payment_report_screen.dart';
import 'expenditure_report_screen.dart';
import 'other_income_report_screen.dart';
import 'statement_report_screen.dart';
import 'hatchery_report_screen.dart';
import 'loan_interest_screen.dart';
import 'check_in_screen.dart';
import 'expenditure_screen.dart';
import 'inventory_loss_screen.dart';
import 'sale_screen.dart';
import 'supply_screen.dart';
import 'work_order_screen.dart';
import '../models/stock_item.dart';
import '../models/report_transaction.dart';
import '../models/payment_report.dart';
import '../models/expenditure_report.dart';
import '../models/other_income_report.dart';
import '../models/statement_report.dart';
import '../models/hatchery_report.dart';
import '../models/loan_interest.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  String? _subTitle;
  List<Map<String, dynamic>>? _subItems;

  static const List<Color> _iconColors = [
    Color(0xFF1E40AF),
    Color(0xFFB91C1C),
    Color(0xFF047857),
    Color(0xFFD97706),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF0284C7),
    Color(0xFFEA580C),
    Color(0xFF0891B2),
    Color(0xFF4F46E5),
    Color(0xFF16A34A),
    Color(0xFF9333EA),
  ];

  static const List<Map<String, dynamic>> _accountItems = [
    {'title': 'Bank', 'icon': Icons.account_balance_outlined},
    {'title': 'Bank Transfer', 'icon': Icons.swap_horiz_outlined},
    {'title': 'Bank Balance', 'icon': Icons.monetization_on_outlined},
    {'title': 'Payment', 'icon': Icons.payment_outlined},
    {'title': 'Other Income', 'icon': Icons.add_circle_outlined},
    {'title': 'Hatchery', 'icon': Icons.egg_outlined},
    {'title': 'Withdrawal', 'icon': Icons.money_off_outlined},
  ];

  static const List<Map<String, dynamic>> _adminItems = [
    {'title': 'Authorization', 'icon': Icons.verified_user_outlined},
    {'title': 'Record Change Approval', 'icon': Icons.edit_note_outlined},
    {'title': 'Access Role', 'icon': Icons.admin_panel_settings_outlined},
  ];

  static const List<Map<String, dynamic>> _productItems = [
    {'title': 'Product Category', 'icon': Icons.category_outlined},
    {'title': 'Products', 'icon': Icons.inventory_outlined},
  ];

  static const List<Map<String, dynamic>> _manufactureItems = [
    {'title': 'Production', 'icon': Icons.precision_manufacturing_outlined},
    {'title': 'Product Stock Entry', 'icon': Icons.inventory_outlined},
  ];

  static const List<Map<String, dynamic>> _stockItems = [
    {'title': 'Product Stock', 'icon': Icons.inventory_outlined},
    {'title': 'Supply Stock', 'icon': Icons.local_shipping_outlined},
  ];

  static const List<Map<String, dynamic>> _reportItems = [
    {'title': 'Sale', 'icon': Icons.shopping_cart_outlined},
    {'title': 'Sale Return', 'icon': Icons.assignment_return_outlined},
    {'title': 'Payment', 'icon': Icons.payment_outlined},
    {'title': 'Expenditure', 'icon': Icons.receipt_outlined},
    {'title': 'Other Income', 'icon': Icons.add_circle_outlined},
    {'title': 'Statement', 'icon': Icons.description_outlined},
    {'title': 'Supply', 'icon': Icons.local_shipping_outlined},
    {'title': 'Hatchery', 'icon': Icons.egg_outlined},
    {'title': 'Loan Interest', 'icon': Icons.percent_outlined},
  ];

  static const _hatcheryItems = [
    {'title': 'Income', 'icon': Icons.trending_up_outlined},
    {'title': 'Expenditure', 'icon': Icons.trending_down_outlined},
  ];

  static const List<StockItem> _supplyStockData = [
    StockItem(
      productName: 'DAP Fertilizer',
      quantityBag: 500, quantityMon: 250, quantityKg: 25000,
      warehouses: [
        WarehouseStock(warehouse: 'Main Warehouse', quantityBag: 300, quantityMon: 150, quantityKg: 15000),
        WarehouseStock(warehouse: 'North Storage', quantityBag: 200, quantityMon: 100, quantityKg: 10000),
      ],
    ),
    StockItem(
      productName: 'Urea',
      quantityBag: 800, quantityMon: 400, quantityKg: 40000,
      warehouses: [
        WarehouseStock(warehouse: 'Main Warehouse', quantityBag: 500, quantityMon: 250, quantityKg: 25000),
        WarehouseStock(warehouse: 'South Storage', quantityBag: 300, quantityMon: 150, quantityKg: 15000),
      ],
    ),
    StockItem(
      productName: 'TSP',
      quantityBag: 350, quantityMon: 175, quantityKg: 17500,
      warehouses: [
        WarehouseStock(warehouse: 'Main Warehouse', quantityBag: 150, quantityMon: 75, quantityKg: 7500),
        WarehouseStock(warehouse: 'East Storage', quantityBag: 200, quantityMon: 100, quantityKg: 10000),
      ],
    ),
  ];

  static const List<ReportTransaction> _saleReportData = [
    ReportTransaction(date: '2026-07-01', invoice: 'INV-001', organization: 'Green Agro', amount: 45000),
    ReportTransaction(date: '2026-07-03', invoice: 'INV-002', organization: 'Rahim Traders', amount: 32000),
    ReportTransaction(date: '2026-07-05', invoice: 'INV-003', organization: 'Hasan Enterprise', amount: 28000),
    ReportTransaction(date: '2026-07-08', invoice: 'INV-004', organization: 'Shah Cement', amount: 56000),
  ];

  static const List<ReportTransaction> _saleReturnReportData = [
    ReportTransaction(date: '2026-07-02', invoice: 'SR-001', organization: 'Green Agro', amount: 12000),
    ReportTransaction(date: '2026-07-06', invoice: 'SR-002', organization: 'Rahim Traders', amount: 8000),
    ReportTransaction(date: '2026-07-09', invoice: 'SR-003', organization: 'Hasan Enterprise', amount: 5000),
  ];

  static const List<PaymentReport> _paymentReportData = [
    PaymentReport(date: '2026-07-01', transId: 'TXN-001', organization: 'Rahim Traders', type: 'Receive', amount: 32000),
    PaymentReport(date: '2026-07-03', transId: 'TXN-002', organization: 'Green Agro', type: 'Payment', amount: 15000),
    PaymentReport(date: '2026-07-06', transId: 'TXN-003', organization: 'Shah Cement', type: 'Receive', amount: 56000),
    PaymentReport(date: '2026-07-09', transId: 'TXN-004', organization: 'Alim Store', type: 'Payment', amount: 8000),
  ];

  static const List<ExpenditureReport> _expenditureReportData = [
    ExpenditureReport(date: '2026-07-02', type: 'Utility', amount: 5000, description: 'Electricity bill'),
    ExpenditureReport(date: '2026-07-05', type: 'Transport', amount: 3200, description: 'Logistics charge'),
    ExpenditureReport(date: '2026-07-08', type: 'Salary', amount: 25000, description: 'Staff salary July'),
    ExpenditureReport(date: '2026-07-11', type: 'Maintenance', amount: 4500, description: 'Equipment repair'),
  ];

  static const List<OtherIncomeReport> _otherIncomeReportData = [
    OtherIncomeReport(date: '2026-07-03', source: 'Rent', consumer: 'Shop Owner', amount: 12000),
    OtherIncomeReport(date: '2026-07-07', source: 'Commission', consumer: 'Broker', amount: 5500),
    OtherIncomeReport(date: '2026-07-10', source: 'Dividend', consumer: 'Shareholder', amount: 8000),
  ];

  static const List<StatementReport> _statementReportData = [
    StatementReport(
      date: '2026-07-01',
      totalIncome: 185000,
      totalCost: 142000,
      profitLoss: 43000,
      breakdown: StatementBreakdown(
        sale: 120000, saleReturn: 8000, supplyAmountReceive: 45000, amountPayment: 32000,
        expenditure: 25000, otherIncome: 12000, withdrawal: 15000, hatcheryIncome: 8000, hatcheryExpense: 5000,
      ),
    ),
    StatementReport(
      date: '2026-07-08',
      totalIncome: 192000,
      totalCost: 158000,
      profitLoss: 34000,
      breakdown: StatementBreakdown(
        sale: 130000, saleReturn: 5000, supplyAmountReceive: 48000, amountPayment: 35000,
        expenditure: 28000, otherIncome: 8000, withdrawal: 12000, hatcheryIncome: 6000, hatcheryExpense: 7000,
      ),
    ),
    StatementReport(
      date: '2026-07-15',
      totalIncome: 168000,
      totalCost: 175000,
      profitLoss: -7000,
      breakdown: StatementBreakdown(
        sale: 100000, saleReturn: 3000, supplyAmountReceive: 55000, amountPayment: 28000,
        expenditure: 32000, otherIncome: 5000, withdrawal: 10000, hatcheryIncome: 4000, hatcheryExpense: 8000,
      ),
    ),
  ];

  static const List<HatcheryReport> _hatcheryReportData = [
    HatcheryReport(date: '2026-07-02', type: 'Income', product: 'Eggs (Layer)', amount: 15000),
    HatcheryReport(date: '2026-07-04', type: 'Expense', product: 'Chick Feed', amount: 8000),
    HatcheryReport(date: '2026-07-09', type: 'Income', product: 'Day-old Chicks', amount: 22000),
    HatcheryReport(date: '2026-07-12', type: 'Expense', product: 'Medicine', amount: 3500),
  ];

  static const List<LoanAccount> _loanAccounts = [
    LoanAccount(loanNo: 'SNL-001', bank: 'Sonali Bank', entries: [
      LoanEntry(date: '2026-07-01', allocation: 500000, repayment: 0, balance: 500000, interest: 0),
      LoanEntry(date: '2026-07-15', allocation: 0, repayment: 50000, balance: 450000, interest: 4500),
    ]),
    LoanAccount(loanNo: 'SNL-002', bank: 'Sonali Bank', entries: [
      LoanEntry(date: '2026-06-01', allocation: 300000, repayment: 0, balance: 300000, interest: 0),
      LoanEntry(date: '2026-07-01', allocation: 0, repayment: 30000, balance: 270000, interest: 2700),
    ]),
    LoanAccount(loanNo: 'DBL-001', bank: 'Dutch Bangla Bank', entries: [
      LoanEntry(date: '2026-05-01', allocation: 800000, repayment: 0, balance: 800000, interest: 0),
      LoanEntry(date: '2026-07-01', allocation: 0, repayment: 80000, balance: 720000, interest: 7200),
    ]),
    LoanAccount(loanNo: 'IBL-001', bank: 'Islami Bank', entries: [
      LoanEntry(date: '2026-04-01', allocation: 1000000, repayment: 0, balance: 1000000, interest: 0),
      LoanEntry(date: '2026-07-01', allocation: 0, repayment: 100000, balance: 900000, interest: 9000),
    ]),
  ];

  static const List<ReportTransaction> _supplyReportData = [
    ReportTransaction(date: '2026-07-02', organization: 'Sonali Suppliers', amount: 15000),
    ReportTransaction(date: '2026-07-04', organization: 'Alim Store', amount: 22000),
    ReportTransaction(date: '2026-07-07', organization: 'Karim Brothers', amount: 18000),
    ReportTransaction(date: '2026-07-10', organization: 'Bashundhara', amount: 35000),
  ];

  static const List<StockItem> _productStockData = [
    StockItem(
      productName: 'Rice BR-28',
      quantityBag: 1200, quantityMon: 600, quantityKg: 60000,
      warehouses: [
        WarehouseStock(warehouse: 'Main Warehouse', quantityBag: 700, quantityMon: 350, quantityKg: 35000),
        WarehouseStock(warehouse: 'West Storage', quantityBag: 500, quantityMon: 250, quantityKg: 25000),
      ],
    ),
    StockItem(
      productName: 'Wheat',
      quantityBag: 900, quantityMon: 450, quantityKg: 45000,
      warehouses: [
        WarehouseStock(warehouse: 'Main Warehouse', quantityBag: 600, quantityMon: 300, quantityKg: 30000),
        WarehouseStock(warehouse: 'North Storage', quantityBag: 300, quantityMon: 150, quantityKg: 15000),
      ],
    ),
    StockItem(
      productName: 'Maize',
      quantityBag: 650, quantityMon: 325, quantityKg: 32500,
      warehouses: [
        WarehouseStock(warehouse: 'Main Warehouse', quantityBag: 400, quantityMon: 200, quantityKg: 20000),
        WarehouseStock(warehouse: 'South Storage', quantityBag: 250, quantityMon: 125, quantityKg: 12500),
      ],
    ),
  ];

  void _openSubGrid(String title, List<Map<String, dynamic>> items) {
    setState(() {
      _subTitle = title;
      _subItems = items;
    });
  }

  void _goBack() {
    setState(() {
      _subTitle = null;
      _subItems = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final module = ModalRoute.of(context)?.settings.arguments as ErpModule?;
    final loc = AppLocalizations.of(context);

    if (module?.title == 'Expenditure') {
      return const ExpenditureScreen();
    }
    if (module?.title == 'Sale') {
      return const SaleScreen();
    }
    if (module?.title == 'Supply') {
      return const SupplyScreen();
    }
    if (module?.title == 'Inventory Loss') {
      return const InventoryLossScreen();
    }
    if (module?.title == 'Check In') {
      return const CheckInScreen();
    }
    if (module?.title == 'Work Order') {
      return const WorkOrderScreen();
    }

    final isAccount = module?.title == 'Account';
    final isAdmin = module?.title == 'Administration';
    final isProduct = module?.title == 'Product';
    final isManufacture = module?.title == 'Manufacture';
    final isStock = module?.title == 'Stock';
    final isReport = module?.title == 'Report';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(_subTitle ?? module?.title ?? loc.modulesTitle),
        centerTitle: true,
        leading: _subTitle != null
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack)
            : null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF19243A),
      ),
      drawer: _subTitle == null ? const ERPDrawer(currentRoute: '/module') : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: isAccount
            ? (_subItems != null ? _buildSubGrid() : _buildAccountGrid())
            : isAdmin
                ? _buildAdminGrid()
                : isProduct
                    ? _buildProductGrid()
                    : isManufacture
                        ? _buildManufactureGrid()
                        : isStock
                            ? _buildStockGrid()
                            : isReport
                                ? _buildReportGrid()
                                : _buildDefaultView(module, loc),
      ),
    );
  }

  Widget _buildAccountGrid() {
    return _buildGenericGrid(_accountItems);
  }

  Widget _buildAdminGrid() {
    return _buildGenericGrid(_adminItems);
  }

  Widget _buildProductGrid() {
    return _buildGenericGrid(_productItems);
  }

  Widget _buildManufactureGrid() {
    return _buildGenericGrid(_manufactureItems);
  }

  Widget _buildStockGrid() {
    return _buildGenericGrid(_stockItems);
  }

  Widget _buildReportGrid() {
    return _buildGenericGrid(_reportItems);
  }

  Widget _buildGenericGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final iconColor = _iconColors[index % _iconColors.length];
        return InkWell(
          onTap: () {
            final title = item['title'] as String;
            if (items == _accountItems) {
              if (title == 'Hatchery') {
                _openSubGrid('Hatchery', _hatcheryItems);
              } else if (title == 'Bank') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BankScreen()));
              } else if (title == 'Bank Transfer') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BankTransferScreen()));
              } else if (title == 'Bank Balance') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BankBalanceScreen()));
              } else if (title == 'Payment') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
              } else if (title == 'Other Income') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OtherIncomeScreen()));
              } else if (title == 'Withdrawal') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WithdrawalScreen()));
              }
            } else if (items == _productItems) {
              if (title == 'Product Category') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductCategoryScreen()));
              } else if (title == 'Products') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen()));
              }
            } else if (items == _stockItems) {
              final stockData = title == 'Supply Stock' ? _supplyStockData : _productStockData;
              Navigator.push(context, MaterialPageRoute(builder: (_) => StockListScreen(title: title, items: stockData)));
            } else if (items == _reportItems) {
              if (title == 'Sale') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ReportListScreen(title: 'Sale', showInvoice: true, items: _saleReportData)));
              } else if (title == 'Sale Return') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ReportListScreen(title: 'Sale Return', showInvoice: true, items: _saleReturnReportData)));
              } else if (title == 'Payment') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentReportScreen(items: _paymentReportData)));
              } else if (title == 'Expenditure') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ExpenditureReportScreen(items: _expenditureReportData)));
              } else if (title == 'Other Income') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => OtherIncomeReportScreen(items: _otherIncomeReportData)));
              } else if (title == 'Statement') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StatementReportScreen(items: _statementReportData)));
              } else if (title == 'Hatchery') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HatcheryReportScreen(items: _hatcheryReportData)));
              } else if (title == 'Loan Interest') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoanInterestScreen(accounts: _loanAccounts)));
              } else if (title == 'Supply') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ReportListScreen(title: 'Supply', showInvoice: false, items: _supplyReportData)));
              }
            }
          },
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item['icon'] as IconData, color: iconColor, size: 18),
                ),
                const SizedBox(height: 6),
                Text(item['title'] as String, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _subItems!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = _subItems![index];
            final iconColor = _iconColors[index % _iconColors.length];
            return InkWell(
              onTap: () {
                final title = item['title'] as String;
                if (_subTitle == 'Hatchery') {
                  if (title == 'Income') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HatcheryIncomeScreen()));
                  } else if (title == 'Expenditure') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HatcheryExpenditureScreen()));
                  }
                }
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item['icon'] as IconData, color: iconColor, size: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(item['title'] as String, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDefaultView(ErpModule? module, AppLocalizations loc) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.layers_outlined, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(module?.title ?? loc.modulesTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(module?.description ?? loc.drawerSubtitle, style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _infoCard(title: 'Overview', value: 'Manage all core operations from one place.'),
        const SizedBox(height: 12),
        _infoCard(title: 'Status', value: 'Healthy • 12 updates today'),
        const SizedBox(height: 12),
        _infoCard(title: 'Action', value: 'Open, review, and complete tasks quickly.'),
      ],
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF19243A))),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }
}