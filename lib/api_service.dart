import 'dart:convert';
import 'package:animation_2/models/ProductItem.dart';
import 'package:animation_2/models/sales-expense-profit.dart';
import 'package:animation_2/models/summaryFoods.dart';
import 'package:animation_2/models/totalQty.dart';
import 'package:animation_2/models/totalSell.dart';
import 'package:animation_2/screens/home/components/category.dart';
import 'package:animation_2/screens/home/components/orders.dart';
import 'package:animation_2/screens/website/expenseItems.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/ExpenseItem.dart';
import 'models/Menu.dart';

class ApiService {
  final String baseUrl = "https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev";

  Future<List<Menu>> fetchMenus() async {
    final response = await http.get(Uri.parse('$baseUrl/menu-list/0'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('Menu ok!');
      return jsonResponse.map((menu) => Menu.fromJson(menu)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category-active'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(responseBody);
      print(data.length);
      print('Category ok!');
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Order> fetchOrders(int? table) async {
    try {
      final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/orders/inprogress/$table'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        print('Orders ok!');
        print(data);
        Order orders = Order.fromJson(data);

        return orders;
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<void> submitOrder(int? orderId, int? table, List<ProductItem> menuCart) async {
    final url = Uri.parse('$baseUrl/orders/submit');
    print('orderId: $orderId , table: $table, menuCart: $menuCart');
    print('Orders ID!');
    final headers = {"Content-Type": "application/json"};
    final List<Map<String, dynamic>> orderItems = menuCart.map((item) {
      return {
        'menuId': item.menu.id,
        'price': item.menu.price,
        'quantity': item.quantity,
        'remark': item.remark,
      };
    }).toList();

    final body = json.encode({
      'orderId': orderId,
      'table': table,
      'orderItems': orderItems,
    });
    print('Request payload: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Order submitted successfully');
    } else {
      print('Failed to submit order: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<List<MenuQty>> totalQty(dynamic date) async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/menu/topMenu/$date'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('totalQty!');
      return jsonResponse.map((json) => MenuQty.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load totalQty');
    }
  }

  Future<TotalExpense> totalExpense(dynamic date) async {
    final response = await http.get(
      Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/summary/sales-expense-profit/$date'),
    );

    if (response.statusCode == 200) {
      // ถ้า API ส่งมาเป็น JSON object เดียว
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('totalExpense!');
      print('totalExpense fetched successfully!');
      return TotalExpense.fromJson(jsonResponse);  // แปลง JSON เป็น TotalExpense เดียว
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to load totalExpense');
    }
  }

  Future<List<FetchStockSimple>> fetchStockSimple() async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/expense/list/filter'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(responseBody);

      print(data.length);
      print('FetchStock ok!');

      // แปลงข้อมูล JSON เป็นลิสต์ของ FetchStock
      return data.map((json) => FetchStockSimple.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<TotalSell>> totalSell() async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/summary/sales-expense-profit/list/'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('totalSell!');
      return jsonResponse.map((json) => TotalSell.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load totalQty');
    }
  }
  Future<List<SummaryFoods>> summaryFoods() async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/summary/sales-menu/list?year=2024&month=10&day=18'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('SummaryFoods!');
      return jsonResponse.map((json) => SummaryFoods.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load SummaryFoods');
    }
  }

}
