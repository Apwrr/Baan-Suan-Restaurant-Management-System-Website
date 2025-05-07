import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/ExpenseItem.dart';
import 'package:animation_2/screens/website/Expire.dart';
import 'package:animation_2/screens/website/StockDetailPage.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock_Details.dart';
import 'package:animation_2/screens/website/summary_Foods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  final HomeController controller = HomeController();
  int selectedYear = 2024;
  int? selectedMonth;
  int? selectedDate;

  Future<List<FetchStockSimple>> fetchStockSimple() async {
    // สร้าง queryParameters สำหรับ month และ day หากถูกเลือก
    String queryParameters = '';
    if (selectedMonth != null) {
      queryParameters += '&month=${selectedMonth.toString().padLeft(2, '0')}';
    }
    if (selectedDate != null) {
      queryParameters += '&day=${selectedDate.toString().padLeft(2, '0')}';
    }

    // ต่อท้าย URL เฉพาะเมื่อมีค่า month หรือ day
    final response = await http.get(Uri.parse(
        'https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/expense/list/filter?year=$selectedYear$queryParameters'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('FetchStock ok!');

      // แปลง jsonResponse เป็น List<FetchStockSimple>
      return jsonResponse.map((json) => FetchStockSimple.fromJson(json)).toList();
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
                      'บันทึกสต๊อก',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('ปี  ', style: TextStyle(fontSize: 18)),
                    DropdownButton<int>(
                      value: selectedYear,
                      items: <int>[2022, 2023, 2024, 2025].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                    ),
                    SizedBox(width: 20),
                    Text('เดือน  ', style: TextStyle(fontSize: 18)),
                    DropdownButton<int?>(
                      value: selectedMonth,
                      hint: Text('เลือก'),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text('-'),
                        ),
                        ...List<int>.generate(12, (index) => index + 1).map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString().padLeft(2, '0')),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue;
                        });
                      },
                    ),
                    SizedBox(width: 20),
                    Text('วัน  ', style: TextStyle(fontSize: 18)),
                    DropdownButton<int?>(
                      value: selectedDate,
                      hint: Text('เลือก'),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text('-'),
                        ),
                        ...List<int>.generate(31, (index) => index + 1).map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedDate = newValue;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // เพิ่มปุ่ม สร้าง
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'รายการบันทึก',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockDetails(controller: controller, expenseItems: []),
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
                      child: Text('สร้าง', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // ตารางเมนูยอดนิยม
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.orange[50],
                    child: SizedBox(
                      width: 1750, // กำหนดความกว้างให้กับ PaginatedDataTable
                      child: FutureBuilder<List<FetchStockSimple>>(
                        future: fetchStockSimple(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            // ตรวจสอบ error
                            print('Error: ${snapshot.error}');
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            // ตรวจสอบว่า snapshot มีข้อมูล
                            print('No data available');
                            return Center(child: Text('No data available'));
                          } else {
                            // ตรวจสอบข้อมูลที่ได้
                            print('Data: ${snapshot.data}');
                            return PaginatedDataTable(
                              showCheckboxColumn: false,
                              columns: [
                                DataColumn(label: Text('วันที่')),
                                DataColumn(label: Text('หมวด')),
                                DataColumn(label: Text('รายการ')),
                                DataColumn(label: Text('จำนวน')),
                                DataColumn(label: Text('ราคา')),
                              ],
                              source: SalesDataSource(snapshot.data!, context),
                              rowsPerPage: 6,
                              columnSpacing: 60,
                              horizontalMargin: 24,
                              headingRowHeight: 56,
                            );
                          }
                        },
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesDataSource extends DataTableSource {
  final List<FetchStockSimple> stocks;
  final BuildContext context;

  SalesDataSource(this.stocks, this.context);

  @override
  DataRow getRow(int index) {
    final stock = stocks[index];
    // แปลงวันที่เป็น วัน-เดือน-ปี
    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(stock.transactionDate));


    return DataRow(
/*      onSelectChanged: (selected) {
        if (selected != null && selected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailPage(expenseItems: stock.expenseItems),
            ),
          );
        }
      },*/
      cells: [
        DataCell(Text(formattedDate)), // วันที่
        DataCell(Text(stock.nameTh)), // หมวด
        DataCell(
          Text(
            stock.expenseItems
                .take(3) // แสดงเฉพาะ 3 รายการแรกของชื่อรายการ
                .map((item) => item.detail)
                .join(", ") +
                (stock.expenseItems.length > 3 ? "..." : ""), // เพิ่ม ... หากมีมากกว่า 3 รายการ
          ),
        ),
        DataCell(
          Text(
            stock.expenseItems
                .take(3) // แสดงเฉพาะ 3 รายการแรกของจำนวนและหน่วย
                .map((item) => '${item.qty} ${item.unit}')
                .join(", ") +
                (stock.expenseItems.length > 3 ? "..." : ""), // เพิ่ม ... หากมีมากกว่า 3 รายการ
          ),
        ),
        DataCell(
          Text(
            stock.expenseItems
                .take(3) // แสดงเฉพาะ 3 รายการแรกของราคา
                .map((item) => item.total.toString())
                .join(", ") +
                (stock.expenseItems.length > 3 ? "..." : " บาท"), // เพิ่ม ... หากมีมากกว่า 3 รายการ
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => stocks.length;

  @override
  int get selectedRowCount => 0;
}
