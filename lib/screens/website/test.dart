/*
import 'package:animation_2/api_service.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/website/add.dart';
import 'package:animation_2/screens/website/adddropdown.dart';
import 'package:animation_2/screens/website/expenseItems.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockDetails extends StatefulWidget {
  final HomeController controller;
  final List<ExpenseItem> expenseItems;

  const StockDetails({Key? key, required this.controller, required this.expenseItems}) : super(key: key);

  @override
  _StockDetailsState createState() => _StockDetailsState();
}

class _StockDetailsState extends State<StockDetails> {
  final TextEditingController detail = TextEditingController();
  int? selectedCategoryId;
  int? selectedMenuId;
  int? selectedIngredientId;

  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  String? selectedCategory;
  String? selectedIngredient;
  List<dynamic> categoryList = [];
  List<dynamic> ingredientList = []; // Data list for ingredients
  List<Widget> itemList = []; // UI list for widgets
  DateTime selectedDate = DateTime.now(); // Selected date

  @override
  void initState() {
    super.initState();
    fetchCategories();

    selectedYear = DateFormat('yyyy').format(DateTime.now());
    selectedMonth = DateFormat('MM').format(DateTime.now());
    selectedDay = DateFormat('dd').format(DateTime.now());
  }

  // ดึงข้อมูลหมวดหมู่จาก API
  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(
        'https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/expense/category-active'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      setState(() {
        categoryList = jsonResponse;
      });
    } else {
      throw Exception('ไม่สามารถโหลดหมวดหมู่ได้');
    }
  }

  void addNewItem() {
    setState(() {
      itemList.add(
        AddNewItem(), // Assumes AddNewItem is a widget for adding new items
      );
    });
  }

  void addDropdown() {
    setState(() {
      itemList.add(
        AddNewItem2(
          onItemAdded: (String name, int qty, double price, String unit) {
            ExpenseItem newItem = ExpenseItem(
              id: 0, // ตั้งค่า id ให้เหมาะสม
              detail: name,
              qty: qty,
              total: price,
              unit: unit,
              menuId: selectedMenuId,
              ingredientId: selectedIngredientId,
            );
            print('Name: $name');
            print('Quantity: $qty');
            print('Price: $price');
            print('Unit: $unit');
            print('MenuId: $selectedMenuId');
            print('IngredientIdd: $selectedIngredientId');
            widget.controller.addExpenseItem(newItem); // เพิ่มรายการไปที่ controller
          },
        ),
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // วันที่เริ่มต้นที่แสดงในปฏิทิน
      firstDate: DateTime(2000), // วันที่แรกที่สามารถเลือกได้
      lastDate: DateTime(2100), // วันที่สุดท้ายที่สามารถเลือกได้
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedYear = DateFormat('yyyy').format(selectedDate);
        selectedMonth = DateFormat('MM').format(selectedDate);
        selectedDay = DateFormat('dd').format(selectedDate);
      });
    }
  }

  Future<void> _saveExpense() async {
    final details = detail.text.trim();
    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('รายละเอียดไม่สามารถเว้นว่างได้')),
      );
      return;
    }

    final transactionDate = selectedDate.toIso8601String();

    if (expenseItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่มีรายการค่าใช้จ่าย')),
      );
      return;
    }

    await widget.controller.submitExpense(
      0, // อัปเดตตามที่ต้องการ
      1, // อัปเดตเป็น categoryId ที่เหมาะสม
      transactionDate,
      details,
      expenseItems,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Website(),
              ),
            );
          },
          child: Text(
            'ค รั ว บ้ า น ส ว น',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        backgroundColor: Color(0xFFD0E2D3),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFD0E2D3),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.note_add),
              title: Text('บันทึกค่าใช้จ่าย'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Stock(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('สรุปยอดขาย'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sell(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('สรุปรายการอาหาร'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Website(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'เลือกหมวดหมู่',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedCategory,
                        items: categoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['nameTh'], // ใช้ชื่อไทยในการแสดง
                            child: Text(category['nameTh']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            itemList.clear(); // เคลียร์รายการที่มีอยู่

                            // ค้นหา category จาก categoryList เพื่อหาค่า nameEn
                            final selectedCategoryEn = categoryList.firstWhere(
                                    (category) =>
                                category['nameTh'] == newValue)['nameEn'];
                            // เช็คเงื่อนไขตาม nameEn
                            if (selectedCategoryEn == 'Main Ingredient' ||
                                selectedCategoryEn == 'Beverage') {
                              addDropdown(); // เพิ่มฟิลด์ใหม่สำหรับหมวดหมู่นี้
                            } else if (selectedCategoryEn ==
                                'Other Ingredient' ||
                                selectedCategoryEn == 'Employee Wage' ||
                                selectedCategoryEn == 'Other') {
                              addNewItem(); // เพิ่มรายการใหม่สำหรับหมวดหมู่นี้
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'ปี/เดือน/วัน',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width:
                          10), // เพิ่มระยะห่างเล็กน้อยระหว่าง Text และปุ่ม
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // สีพื้นหลังของปุ่มเป็นสีขาว
                          onPrimary: Colors.black, // สีของข้อความในปุ่มเป็นสีดำ
                          minimumSize:
                          Size(50, 30), // ขนาดของปุ่ม (กว้าง x สูง)
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          side: BorderSide(color: Colors.black), // ขอบปุ่มสีดำ
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 14), // ขนาดฟอนต์เล็กลง
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "$selectedDay/$selectedMonth/$selectedYear",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'รายละเอียด',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: detail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'รายละเอียด',
                    ),
                  ),
                  SizedBox(height: 20),
                  ...itemList, // แสดงรายการที่เพิ่มใหม่
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveExpense, // เรียกใช้ฟังก์ชันบันทึก
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Text(
                        "บันทึก",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
