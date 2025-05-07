class FetchExpireSimple {
  final int id;
  final int ingredientId;
  final String name;
  final double qty;
  final String unit;
  final DateTime expiredDate;

  FetchExpireSimple({
    required this.id,
    required this.ingredientId,
    required this.name,
    required this.qty,
    required this.unit,
    required this.expiredDate,
  });

  // Factory constructor to parse JSON and create a FetchExpireSimple instance
  factory FetchExpireSimple.fromJson(Map<String, dynamic> json) {
    return FetchExpireSimple(
      id: json['id'] ?? 0,
      ingredientId: json['ingredientId'] ?? 0,
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      unit: json['unit'] ?? '',
      expiredDate: DateTime.parse(json['expiredDate'] ?? ''),
    );
  }
}