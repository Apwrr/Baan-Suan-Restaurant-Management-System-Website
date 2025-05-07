class MenuQty {
  final int menuId;
  final String menuName;
  final int totalQuantity;

  MenuQty({
    required this.menuId,
    required this.menuName,
    required this.totalQuantity,
  });

  factory MenuQty.fromJson(Map<String, dynamic> json) {
    return MenuQty(
      menuId: json['menuId'],
      menuName: json['menuName'],
      totalQuantity: json['totalQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'totalQuantity': totalQuantity,
    };
  }
}