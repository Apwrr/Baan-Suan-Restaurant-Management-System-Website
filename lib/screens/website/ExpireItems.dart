class Expires{
  List<ExpireItem> expireItems;

  Expires({
    required this.expireItems,
  });

  // แปลงจาก JSON
  factory Expires.fromJson(Map<String, dynamic> json) {
    return Expires(
      expireItems: json['expireItems'] != null
          ? List<ExpireItem>.from(json['expireItems'].map((item) => ExpireItem.fromJson(item)))
          : [],
    );
  }

  // แปลงกลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'expireItems': expireItems.map((item) => item.toJson()).toList(),
    };
  }
}

class ExpireItem {
  int id;
  int ingredientId;
  String name;
  double qty;
  String unit;
  DateTime expiredDate;

  ExpireItem({
    required this.id,
    required this.ingredientId,
    required this.qty,
    required this.name,
    required this.unit,
    required this.expiredDate,

  });

  factory ExpireItem.fromJson(Map<String, dynamic> json) {
    return ExpireItem(
      id: json['id'] ?? 0,
      ingredientId: json['ingredientId'] ?? 0,
      qty: json['qty'] ?? 0,
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      expiredDate: DateTime.parse(json['expiredDate']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredientId': ingredientId,
      'qty': qty,
      'name': name,
      'unit': unit,
      'expiredDate': expiredDate.toIso8601String(),
    };
  }
}