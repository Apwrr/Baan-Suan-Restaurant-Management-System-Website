class SummaryFoods {
  final String nameTh;
  final int qty;
  String createdDate;

  SummaryFoods({
    required this.nameTh,
    required this.qty,
    required this.createdDate,
  });

  factory SummaryFoods.fromJson(Map<String, dynamic> json) {
    return SummaryFoods(
      nameTh: json['nameTh'],
      qty: json['qty'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameTh': nameTh,
      'totalExpense': qty,
      'createdDate': createdDate,
    };
  }
}
