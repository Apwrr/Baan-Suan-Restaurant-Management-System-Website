import 'package:animation_2/screens/website/Expire.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';


class SummaryFoods extends StatefulWidget {
  @override
  _SummaryFoodsState createState() => _SummaryFoodsState();
}

class _SummaryFoodsState extends State<SummaryFoods> {
  int selectedYear = 2024;
  int? selectedMonth;
  int? selectedDate;

  Future<List<Map<String, dynamic>>> fetchSummaryFoodsData() async {
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
        'https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/summary/sales-menu/list?year=$selectedYear$queryParameters'));

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
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // ปรับความกว้าง
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'สรุปรายการอาหาร',
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
                    DropdownButton<int>(
                      value: selectedMonth,
                      hint: Text('เลือก'),
                      items: [
                        DropdownMenuItem<int>(
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
                    DropdownButton<int>(
                      value: selectedDate,
                      hint: Text('เลือก'),
                      items: [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text('-'), // ข้อความสำหรับตัวเลือก null
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.orange[50],
                    child: SizedBox(
                      width: 1750,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchSummaryFoodsData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('ไม่มีข้อมูล');
                          } else {
                            return PaginatedDataTable(
                              columns: [
                                DataColumn(label: Center(child: Text('วันที่'))),
                                DataColumn(label: Center(child: Text('เมนู'))),
                                DataColumn(label: Center(child: Text('จำนวน'))),
                              ],
                              source: SalesDataSource(snapshot.data!),
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

  SalesDataSource(this.salesData);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= salesData.length) return null;
    final sale = salesData[index];

    // แปลง summaryDate เป็น วัน-เดือน-ปี
    String formattedDate = 'N/A';
    if (sale['createdDate'] != null) {
      try {
        final date = DateTime.parse(sale['createdDate']);
        formattedDate = DateFormat('dd-MM-yyyy').format(date);
      } catch (e) {
        print('Error formatting date: $e');
      }
    }

    return DataRow.byIndex(index: index, cells: [
      DataCell(SizedBox(
        width: 100,
        child: Center(child: Text(formattedDate)), // ใช้วันที่ที่จัดรูปแบบแล้ว
      )),
      DataCell(SizedBox(
        width: 100,
        child: Text(sale['nameTh'].toString()),
      )),
      DataCell(SizedBox(
        width: 50,
        child: Center(child: Text(sale['qty'].toString())),
      )),
    ]);
  }

  @override
  int get rowCount => salesData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}