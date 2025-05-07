class ExpenseItemSimple {
  final int id;
  final String detail;
  final double qty;
  final double total;
  final String? unit;

  ExpenseItemSimple({
    required this.id,
    required this.detail,
    required this.qty,
    required this.total,
    this.unit,
  });

  // แปลง JSON เป็น ExpenseItemSimple
  factory ExpenseItemSimple.fromJson(Map<String, dynamic> json) {
    return ExpenseItemSimple(
      id: json['id'] ?? 0,
      detail: json['detail'] ?? '',
      qty: json['qty']?.toDouble() ?? 0.0, // ใช้ 'qty' แทน 'quantity'
      total: json['total']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
    );
  }
}

class FetchStockSimple {
  final String transactionDate;
  final String detail;
  final String nameTh;
  final List<ExpenseItemSimple> expenseItems;

  FetchStockSimple({
    required this.transactionDate,
    required this.detail,
    required this.nameTh,
    required this.expenseItems,
  });

  // แปลง JSON เป็น FetchStockSimple
  factory FetchStockSimple.fromJson(Map<String, dynamic> json) {
    return FetchStockSimple(
      transactionDate: json['transactionDate'] ?? '',
      detail: json['detail'] ?? '',
      nameTh: json['expenseCategory']['nameTh'] ?? '',  // ดึง 'nameTh' จาก 'expenseCategory'
      expenseItems: [
        ExpenseItemSimple.fromJson(json) // ใช้ JSON ข้อมูลเดียวสร้าง ExpenseItemSimple
      ],
    );
  }
}
