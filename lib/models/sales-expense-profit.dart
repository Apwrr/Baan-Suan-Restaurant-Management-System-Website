class TotalExpense {
  final double totalSales;
  final double totalExpense;
  final double totalProfit;

  TotalExpense({
    required this.totalSales,
    required this.totalExpense,
    required this.totalProfit,
  });

  factory TotalExpense.fromJson(Map<String, dynamic> json) {
    return TotalExpense(
      totalSales: json['totalSales'],
      totalExpense: json['totalExpense'],
      totalProfit: json['totalProfit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalExpense': totalExpense,
      'totalProfit': totalProfit,
    };
  }
}