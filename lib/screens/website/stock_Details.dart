import 'package:animation_2/api_service.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/website/Expire.dart';
import 'package:animation_2/screens/website/add.dart';
import 'package:animation_2/screens/website/adddropdown.dart';
import 'package:animation_2/screens/website/dropdownBeverage.dart';
import 'package:animation_2/screens/website/expenseItems.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock.dart';
import 'package:animation_2/screens/website/summary_Foods.dart';
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
  List<dynamic> ingredientList = [];
  List<GlobalKey<AddNewItemState>> itemKeys = [];
  List<GlobalKey<AddNewItem2State>> itemKey = [];
  List<GlobalKey<AddNewItem3State>> itemKey3 = [];
  List<Widget> itemList = [];
  DateTime selectedDate = DateTime.now();
  List<ExpenseItem> expenseItems = [];

  void _addItemToExpense(ExpenseItem item) {
    setState(() {
      expenseItems.add(item);
    });
  }
  void _removeItemFromExpense(ExpenseItem itemToRemove) {
    setState(() {
      expenseItems.removeWhere((item) =>
      item.detail == itemToRemove.detail &&
          item.unit == itemToRemove.unit);
    });
  }
  void _removeWidget(GlobalKey<AddNewItemState> keys) {
    setState(() {
      int index = itemKeys.indexOf(keys); // หาตำแหน่งของ widget ที่มี GlobalKey ตรงกัน
      if (index != -1) {
        itemKeys.removeAt(index); // ลบคีย์ออกจากรายการ
        itemList.removeAt(index); // ลบ widget ออกจาก itemList
      }
    });
  }
  void _removeWidget2(GlobalKey<AddNewItem2State> key) {
    setState(() {
      int index = itemKey.indexOf(key); // หาตำแหน่งของ widget ที่มี GlobalKey ตรงกัน
      if (index != -1) {
        itemKey.removeAt(index); // ลบคีย์ออกจากรายการ
        itemList.removeAt(index); // ลบ widget ออกจาก itemList
      }
    });
  }
  void _removeWidget3(GlobalKey<AddNewItem3State> key3) {
    setState(() {
      int index = itemKey3.indexOf(key3); // หาตำแหน่งของ widget ที่มี GlobalKey ตรงกัน
      if (index != -1) {
        itemKey3.removeAt(index); // ลบคีย์ออกจากรายการ
        itemList.removeAt(index); // ลบ widget ออกจาก itemList
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();

    selectedYear = DateFormat('yyyy').format(DateTime.now());
    selectedMonth = DateFormat('MM').format(DateTime.now());
    selectedDay = DateFormat('dd').format(DateTime.now());
  }

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
    final keys = GlobalKey<AddNewItemState>();
    itemKeys.add(keys);

    setState(() {
      itemList.add(
        AddNewItem(
          keys: keys,
          onItemAdded: (ExpenseItem newItem) {
            _addItemToExpense(newItem);
            print('Added Expense Item: ${newItem.detail}');
          },
          onItemRemoved: (item) {
            _removeItemFromExpense(item);
            _removeWidget(keys);
          },
        ),
      );
    });
  }

  void addDropdown() {
    final key = GlobalKey<AddNewItem2State>();
    itemKey.add(key);

    setState(() {
      itemList.add(
        AddNewItem2(
          key: key,
          onItemAdded: (ExpenseItem newItem) {
            _addItemToExpense(newItem);
            print('Added Expense Item: ${newItem.detail}');
          },
          onItemRemoved: (item) {
            _removeItemFromExpense(item);
            _removeWidget2(key);
          },
        ),
      );
    });
  }

  void addDropdownBeverage() {
    final key3 = GlobalKey<AddNewItem3State>();
    itemKey3.add(key3);

    setState(() {
      itemList.add(
        AddNewItem3(
          key3: key3,
          onItemAdded: (ExpenseItem newItem) {
            _addItemToExpense(newItem);
            print('Added Expense Item: ${newItem.detail}');
          },
          onItemRemoved: (item) {
            _removeItemFromExpense(item);
            _removeWidget3(key3);
          },
        ),
      );
    });
  }

  void _updateDate(DateTime date) {
    print("วันที่ถูกเลือก: ${date.toIso8601String()}");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedYear = DateFormat('yyyy').format(selectedDate);
        selectedMonth = DateFormat('MM').format(selectedDate);
        selectedDay = DateFormat('dd').format(selectedDate);
      });
      _updateDate(selectedDate);
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

    for (var key in itemKey) {
      key.currentState?.saveItem();
    }
    for (var keys in itemKeys) {
      keys.currentState?.saveItem();
    }
    for (var key3 in itemKey3) {
      key3.currentState?.saveItem();
    }

    final transactionDate = selectedDate.toIso8601String();

    for (var item in expenseItems) {
      print('Expense Item: ${item.detail}');
      print(' - Quantity: ${item.qty}');
      print(' - Total: ${item.total}');
      print(' - Unit: ${item.unit}');
      print(' - Ingredient ID: ${item.ingredientId}');
      print(' - Menu ID: ${item.menuId}');
    }
    if (expenseItems.isEmpty) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่มีรายการค่าใช้จ่าย')),
      );*/
      return;
    }

    await widget.controller.submitExpense(
      0,
      selectedCategoryId!,
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
        leading: BackButton(
          color: Colors.black,
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Website(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ค รั ว บ้ า น ส ว น',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(width: 8), // ระยะห่างระหว่างข้อความกับไอคอน
              Icon(
                Icons.home, // ไอคอนรูปบ้าน
                color: Colors.black,
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFFD0E2D3),
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
                'เมนู',
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
                    builder: (context) => SummaryFoods(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.no_food_outlined),
              title: Text('วัตถุดิบหมดอายุ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Expire()),
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
                        'หมวดหมู่',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        hint: Text('กรุณาเลือกหมวดหมู่'),
                        value: selectedCategory,
                        items: categoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['nameTh'],
                            child: Text(category['nameTh']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            itemList.clear();

                            final selectedCategoryData = categoryList.firstWhere(
                                    (category) => category['nameTh'] == newValue
                            );
                            final selectedCategoryEn = selectedCategoryData['nameEn'];
                            selectedCategoryId = selectedCategoryData['id'];

                            if (selectedCategoryEn == 'Main Ingredient') {
                              addDropdown();
                            } else if (selectedCategoryEn == 'Beverage') {
                              addDropdownBeverage();
                            } else if (selectedCategoryEn == 'Other Ingredient' ||
                                selectedCategoryEn == 'Employee Wage' ||
                                selectedCategoryEn == 'Other') {
                              addNewItem();
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
                        'วัน/เดือน/ปี',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          minimumSize: Size(50, 30),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          side: BorderSide(color: Colors.black),
                        ),
                        child: Text(
                          "แก้ไข",
                          style: TextStyle(fontSize: 14),
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
                  Column(
                    children: itemList,
                  ),
                  SizedBox(height: 20),
                  if (selectedCategory == 'วัตถุดิบหลัก')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: addDropdown,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            "เพิ่มแถว +",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  if (selectedCategory == 'เครื่องดื่ม')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: addDropdownBeverage,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            "เพิ่มแถว +",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  if (selectedCategory == 'วัตถุดิบอื่นๆ' || selectedCategory == 'ค่าจ้างพนักงาน' || selectedCategory == 'อื่นๆ' )
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: addNewItem,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            "เพิ่มแถว +",
                            style: TextStyle(color: Colors.white),
                          ),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveExpense,
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
