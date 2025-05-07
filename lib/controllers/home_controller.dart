import 'dart:convert'; // สำหรับ json.encode
import 'dart:async';
import 'package:animation_2/models/ExpenseItem.dart';
import 'package:animation_2/screens/website/Expire.dart';
import 'package:animation_2/screens/website/ExpireItems.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animation_2/screens/home/components/orders.dart';
import 'package:animation_2/models/Menu.dart';
import 'package:animation_2/models/ProductItem.dart';
import 'package:animation_2/api_service.dart';
import 'package:animation_2/screens/website/expenseItems.dart';

enum HomeState {
  normal,
  cart,
}

class HomeController extends ChangeNotifier {
  HomeState _homeState = HomeState.normal;
  List<ProductItem> _menuCart = [];
  Order orders = Order(
    id: 0,
    table: 0,
    orderNo: '',
    status: '',
    orderItemDtoList: [],
  );

  final ApiService _apiService = ApiService();
  Timer? _orderRefreshTimer;

  HomeState get homeState => _homeState;
  List<ProductItem> get menuCart => _menuCart;
  Order get orderItems => orders;

  List<ExpenseItem> expenseItem = [];
  Expense expense = Expense(
    id: 0,
    expenseCategoryId: 0,
    transactionDate: DateTime.now(), // กำหนดค่าเริ่มต้น
    detail: '',
    expenseItems: [],
  );

  List<ExpenseItem> get expenseItems => expenseItem;
  Expense get expenseHeader => expense;

  // Method to update the list of expense items
  void updateExpenseItems(List<ExpenseItem> items) {
    expenseItem = items;
    notifyListeners();
  }

  void addExpenseItem(ExpenseItem item) {
    expenseItems.add(item);
    notifyListeners(); // เพิ่มการแจ้งเตือนเมื่อมีการเพิ่มรายการใหม่
  }

  // Method to update the expense header
  void updateExpenseHeader(Expense newExpense) {
    expense = newExpense;
    notifyListeners();
  }

  // Method to submit expense data to the API
  Future<void> submitExpense(int id, int expenseCategoryId, String transactionDate, String detail, List<ExpenseItem> expenseItems) async {
    final url = Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/expense/submit');
    final headers = {"Content-Type": "application/json"};
    print('ID cat: $expenseCategoryId');

    final List<Map<String, dynamic>> expenseItemsJson = expenseItems.map((item) {
      return {
        'Id': item.id,
        'detail': item.detail,
        'qty': item.qty,
        'total': item.total,
        'unit': item.unit,
        'menuId': item.menuId ?? 0,
        'ingredientId': item.ingredientId ?? 0,
      };
    }).toList();

    final body = json.encode({
      'id': expense.id,
      'expenseCategoryId': expenseCategoryId,
      'transactionDate':transactionDate,
      'detail': detail,
      'expenseItems': expenseItemsJson,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Expense submitted successfully');
      } else {
        print('Failed to submit expense: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Failed to submit expense: $e');
    }
  }
  List<ExpireItem> expireItem = [];
  Expires expire = Expires(
   expireItems: [],
  );

  List<ExpireItem> get expireItems => expireItem;
  Expires get expireHeader => expire;

  // Method to update the list of expense items
  void updateExpireItem(List<ExpireItem> items) {
    expireItem = items;
    notifyListeners();
  }

  void addExpireItem(ExpireItem item) {
    expireItem.add(item);
    notifyListeners(); // เพิ่มการแจ้งเตือนเมื่อมีการเพิ่มรายการใหม่
  }

  // Method to update the expense header
  void updateExpireHeader(Expires newExpense) {
    expire = newExpense;
    notifyListeners();
  }

  // Method to submit expense data to the API
  Future<void> submitExpire(List<ExpireItem> expireItems) async {
    final url = Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/ingredient/expire/submit');
    final headers = {"Content-Type": "application/json"};


    final List<Map<String, dynamic>> expireItemsJson = expireItems.map((item) {
      return {
        'id': item.id,
        'name': item.name,
        'qty': item.qty,
        'unit': item.unit,
        'ingredientId': item.ingredientId,
      };
    }).toList();

    final body = json.encode({
      'expireItems': expireItemsJson,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Expire submitted successfully');
      } else {
        print('Failed to submit expire: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Failed to submit expire: $e');
    }
  }

  void changeHomeState(HomeState state) {
    _homeState = state;
    notifyListeners();
  }

  void addProductToCart(Menu menu, int quantity, String remark) {
    for (var item in _menuCart) {
      if (item.menu == menu && item.remark == remark) {
        item.quantity += quantity;
        notifyListeners();
        return;
      }
    }
    _menuCart.add(ProductItem(menu: menu, quantity: quantity, remark: remark));
    notifyListeners();
  }

  void updateProductQuantity(ProductItem productItem, int newQuantity) {
    for (var item in _menuCart) {
      if (item == productItem) {
        item.quantity = newQuantity;
        if (item.quantity <= 0) {
          _menuCart.remove(item);
        }
        notifyListeners();
        return;
      }
    }
  }

  void incrementItem(ProductItem item) {
    item.increment();
    notifyListeners();
  }

  void decrementItem(ProductItem item) {
    item.decrement();
    if (item.quantity <= 0) {
      _menuCart.remove(item);
    }
    notifyListeners();
  }

  void removeProductFromCart(ProductItem productItem) {
    _menuCart.remove(productItem);
    notifyListeners();
  }

  void moveCartToOrder() {
    _menuCart.clear();
    notifyListeners();
  }

  int totalCartItems() {
    int total = 0;
    for (var item in _menuCart) {
      total += item.quantity;
    }
    return total;
  }

  Future<void> fetchOrders(int table) async {
    try {
      orders = await _apiService.fetchOrders(table);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch orders: $e');
    }
  }


  // Method to update orderId without resetting
  void updateOrderId(int id) {
    if (orders.id == 0) {
      orders.id = id;
    }
  }

  // Method to refresh orders periodically
  void startOrderRefresh(int table) {
    stopOrderRefresh(); // Ensure any existing timer is cancelled
    _orderRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await fetchOrders(table);
    });
  }

  // Method to stop the periodic refresh
  void stopOrderRefresh() {
    _orderRefreshTimer?.cancel();
  }

  @override
  void dispose() {
  }}