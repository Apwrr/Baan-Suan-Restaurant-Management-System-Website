import 'package:animation_2/api_service.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/website/Expire.dart';
import 'package:animation_2/screens/website/ExpireItems.dart';
import 'package:animation_2/screens/website/add.dart';
import 'package:animation_2/screens/website/addExpire.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock.dart';
import 'package:animation_2/screens/website/summary_Foods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpireDetails extends StatefulWidget {
  final HomeController controller;
  final List<ExpireItem> expireItems;

  const ExpireDetails({Key? key, required this.controller, required this.expireItems}) : super(key: key);

  @override
  _ExpireDetailsState createState() => _ExpireDetailsState();
}

class _ExpireDetailsState extends State<ExpireDetails> {
  final TextEditingController detail = TextEditingController();
  int? selectedCategoryId;
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  List<GlobalKey<AddExpireState>> itemKeys = [];
  List<Widget> itemList = [];
  DateTime selectedDate = DateTime.now();
  List<ExpireItem> expireItems = [];

  @override
  void initState() {
    super.initState();

    selectedYear = DateFormat('yyyy').format(DateTime.now());
    selectedMonth = DateFormat('MM').format(DateTime.now());
    selectedDay = DateFormat('dd').format(DateTime.now());

    // Add the first item when the widget initializes
    addNewItem();
  }

  void _addItemToExpire(ExpireItem item) {
    setState(() {
      expireItems.add(item);
    });
  }

  void _removeItemFromExpire(ExpireItem itemToRemove) {
    setState(() {
      expireItems.removeWhere((item) =>
          item.name == itemToRemove.name);
    });
  }

  void _removeWidget(GlobalKey<AddExpireState> key) {
    setState(() {
      int index = itemKeys.indexOf(key);
      if (index != -1) {
        itemKeys.removeAt(index);
        itemList.removeAt(index);
      }
    });
  }

  void addNewItem() {
    final key = GlobalKey<AddExpireState>();
    itemKeys.add(key);

    setState(() {
      itemList.add(
        AddExpire(
          key: key,
          onItemAdded: (ExpireItem newItem) {
            _addItemToExpire(newItem);
            print('Added Expire Item: ${newItem.ingredientId}');
          },
          onItemRemoved: (item) {
            _removeItemFromExpire(item);
            _removeWidget(key);
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

  Future<void> _saveExpire() async {

    for (var keys in itemKeys) {
      keys.currentState?.saveItem();
    }



    for (var item in expireItems) {

      print(' - Quantity: ${item.qty}');
      print(' - Unit: ${item.name}');
      print(' - Ingredient ID: ${item.ingredientId}');

    }
    if (expireItems.isEmpty) {
      return;
    }

    await widget.controller.submitExpire(
      expireItems,
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
                  Text(
                    'รายการวัตถุดิบหมดอายุ',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'วัน/เดือน/ปี',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveExpire,
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
