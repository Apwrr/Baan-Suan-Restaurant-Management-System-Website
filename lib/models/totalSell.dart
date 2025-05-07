class TotalSell {
  final int totalSales;
  final int totalExpense;
  final int totalProfit;
  String summaryDate;

  TotalSell({
    required this.totalSales,
    required this.totalExpense,
    required this.totalProfit,
    required this.summaryDate,
  });

  factory TotalSell.fromJson(Map<String, dynamic> json) {
    return TotalSell(
      totalSales: json['totalSales'],
      totalExpense: json['totalExpense'],
      totalProfit: json['totalProfit'],
      summaryDate: json['summaryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalExpense': totalExpense,
      'totalProfit': totalProfit,
      'summaryDate': summaryDate,
    };
  }
}
