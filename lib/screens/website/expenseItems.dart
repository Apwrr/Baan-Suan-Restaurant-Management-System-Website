class Expense {
  int id;
  int expenseCategoryId;
  DateTime transactionDate; // เปลี่ยนเป็น DateTime
  String detail;
  List<ExpenseItem> expenseItems;

  Expense({
    required this.id,
    required this.expenseCategoryId,
    required this.transactionDate, // ใช้ DateTime แทน String
    required this.detail,
    required this.expenseItems,
  });

  // แปลงจาก JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? 0,
      expenseCategoryId: json['expenseCategoryId'] ?? 0,
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate']) // แปลงเป็น DateTime
          : DateTime.now(), // ค่าเริ่มต้นเป็นวันที่ปัจจุบันถ้าไม่มีข้อมูล
      detail: json['detail'] ?? '',
      expenseItems: json['expenseItems'] != null
          ? List<ExpenseItem>.from(json['expenseItems'].map((item) => ExpenseItem.fromJson(item)))
          : [],
    );
  }

  // แปลงกลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseCategoryId': expenseCategoryId,
      'transactionDate': transactionDate.toIso8601String(), // แปลง DateTime กลับเป็น String
      'detail': detail,
      'expenseItems': expenseItems.map((item) => item.toJson()).toList(),
    };
  }
}

class ExpenseItem {
  int id;
  String detail;
  double qty;
  double total;
  String unit;
  int? menuId;
  int? ingredientId;

  ExpenseItem({
    required this.id,
    required this.detail,
    required this.qty,
    required this.total,
    required this.unit,
    this.menuId,
    this.ingredientId,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      id: json['id'] ?? 0,
      detail: json['detail'] ?? '',
      qty: json['qty'] ?? 0,
      total: json['total'] ?? 0,
      unit: json['unit'] ?? '',
      menuId: json['menuId'],
      ingredientId: json['ingredientId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'detail': detail,
      'qty': qty,
      'total': total,
      'unit': unit
    };
    // Include menuId only if it's not null
    if (menuId != null) {
      data['menuId'] = menuId;
    }
    if (ingredientId != null) {
      data['ingredientId'] = ingredientId;
    }

    return data;
  }
}
