import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/ExpenseItem.dart';
import 'package:animation_2/models/ExpireItem.dart';
import 'package:animation_2/screens/website/ExpireItems.dart';
import 'package:animation_2/screens/website/Expire_Details.dart';
import 'package:animation_2/screens/website/StockDetailPage.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock.dart';
import 'package:animation_2/screens/website/stock_Details.dart';
import 'package:animation_2/screens/website/summary_Foods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Expire extends StatefulWidget {
  @override
  _ExpireState createState() => _ExpireState();
}

class _ExpireState extends State<Expire> {
  final HomeController controller = HomeController();
  int selectedYear = 2024;
  int? selectedMonth;
  int? selectedDate;
  List<bool> selectedRows = [];

  Future<List<Map<String, dynamic>>> fetchExpireSimple() async {
    // สร้าง queryParameters สำหรับ month และ day หากถูกเลือก
    String queryParameters = '';
    if (selectedMonth != null) {
      queryParameters += '&month=${selectedMonth.toString().padLeft(2, '0')}';
    }
    if (selectedDate != null) {
      queryParameters += '&day=${selectedDate.toString().padLeft(2, '0')}';
    }

    // ต่อท้าย URL เฉพาะเมื่อมีค่า month หรือ day
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/ingredient/stock-usage/expired/list'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
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
              MaterialPageRoute(builder: (context) => Website()),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ข้อมูลสรุปด้านบน
                Row(
                  children: [
                    Text(
                      'รายการวัตถุดิบหมดอายุ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'วันที่: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(DateTime.now()), // ใช้วันที่ปัจจุบัน หรือข้อมูลวันที่ที่ได้จาก API
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // เพิ่มปุ่ม สร้าง
/*                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpireDetails(controller: controller, expireItems: []),
                          ),
                        ).then((_) {
                          setState(() {
                            // รีเฟรชหน้าหลังจากปิดหน้า StockDetails
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      child: Text('สร้างรายการ', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),*/
                SizedBox(height: 10),
                // ตารางเมนูยอดนิยม
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.orange[50],
                    child: SizedBox(
                      width: 1750,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchExpireSimple(),
                        builder: (context, snapshot,) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('ไม่มีข้อมูล');
                          } else {
                            selectedRows = List.generate(snapshot.data!.length, (_) => false);
                            return PaginatedDataTable(
                              columns: [
                                DataColumn(label: Center(child: Text('รายการ'))),
                                DataColumn(label: Center(child: Text('จำนวน'))),
                                DataColumn(label: Center(child: Text('วันที่หมดอายุ'))),
                                DataColumn(label: Center(child: Text('ลบ'))),
                              ],
                              source: SalesDataSource(snapshot.data!, context, controller),
                              rowsPerPage: 6,
                              columnSpacing: 60,
                              horizontalMargin: 24,
                              headingRowHeight: 56,
                            );

                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SalesDataSource extends DataTableSource {
  final List<Map<String, dynamic>> salesData;
  final BuildContext context;
  final HomeController controller;

  SalesDataSource(this.salesData, this.context,this.controller) {

  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= salesData.length) return null;
    final expire = salesData[index];
    // แปลง summaryDate เป็น วัน-เดือน-ปี
    String formattedDate = 'N/A';
    if (expire['expiredDate'] != null) {
      try {
        final date = DateTime.parse(expire['expiredDate']);
        formattedDate = DateFormat('dd-MM-yyyy').format(date);
      } catch (e) {
        print('Error formatting date: $e');
      }
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(SizedBox(
          width: 100,
          child: Text(expire['name'].toString()),
        )),
        DataCell(SizedBox(
          width: 100,
          child: Text('${expire['qty']} ${expire['unit']}'),
        )),
        DataCell(SizedBox(
          width: 100,
          child: Center(child: Text(formattedDate)),
        )),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteConfirmationDialog(index, expire['name']);
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(int index, String itemName) {
    String expirationDate = salesData[index]['expiredDate'];
    DateTime parsedDate = DateTime.parse(expirationDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบ "$itemName" ที่หมดอายุแล้ว วันที่ $formattedDate ใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(index);
                Navigator.of(context).pop();
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveExpire(Map<String, dynamic> item) async {
    ExpireItem expireItem = ExpireItem(
      id: item['id'],
      ingredientId: item['ingredientId'],
      qty: item['qty'],
      name: item['name'],
      unit: item['unit'],
      expiredDate: DateTime.parse(item['expiredDate']),

    );

    await controller.submitExpire([expireItem]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('บันทึกการลบสำเร็จ')),
    );
  }

  void _deleteItem(int index) {
    final item = salesData[index]; // เก็บรายการที่ต้องการลบไว้ก่อน
    salesData.removeAt(index);
    notifyListeners(); // รีเฟรชตารางข้อมูล

    // เรียกใช้ _saveExpire โดยส่งรายการที่ถูกลบไป
    _saveExpire(item);
  }

  @override
  int get rowCount => salesData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}