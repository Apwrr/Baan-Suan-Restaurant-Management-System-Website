class Menu {
  final int? id;
  final String? nameTh;
  final String? imagePath;
  final double? price;
  final String? status;
  final int? menuCategoryId;
  final bool isAvailable; // เพิ่มพารามิเตอร์นี้

  Menu({
    this.id,
    this.nameTh,
    this.imagePath,
    this.price,
    this.status,
    this.menuCategoryId,
    this.isAvailable = true, // กำหนดค่าเริ่มต้นเป็น true
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      nameTh: json['nameTh'],
      imagePath: json['imagePath'],
      price: json['price'],
      menuCategoryId: json['menuCategoryId'],
      isAvailable: json['isAvailable'] ?? true, // ใช้ค่าเริ่มต้นเป็น true หากไม่พบใน JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameTh': nameTh,
      'imagePath': imagePath,
      'price': price,
      'menuCategoryId': menuCategoryId,
      'isAvailable': isAvailable, // เพิ่มพารามิเตอร์นี้
    };
  }
}
