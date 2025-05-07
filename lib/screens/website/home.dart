import 'package:animation_2/api_service.dart';
import 'package:animation_2/models/sales-expense-profit.dart';
import 'package:animation_2/models/totalQty.dart';
import 'package:animation_2/screens/website/Expire.dart';
import 'package:animation_2/screens/website/sell.dart';
import 'package:animation_2/screens/website/stock.dart';
import 'package:animation_2/screens/website/summary_Foods.dart';
import 'package:flutter/material.dart';

class Website extends StatefulWidget {
  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  late Future<List<MenuQty>> _menuListFuture;
  late Future<TotalExpense> _totalExpenseFuture; // ตัวแปรสำหรับเก็บ TotalExpense

  @override
  void initState() {
    super.initState();
    _menuListFuture = fetchData();
    _totalExpenseFuture = fetchTotal(); // ดึงข้อมูล TotalExpense จาก API
  }

  Future<List<MenuQty>> fetchData() async {
    final apiService = ApiService(); // สร้าง instance ของ ApiService
    // ดึงวันที่ปัจจุบันในรูปแบบ 'YYYY-MM'
    String currentDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";

    return await apiService.totalQty(currentDate); // ใช้ปีและเดือนปัจจุบัน
  }

  Future<TotalExpense> fetchTotal() async {
    final apiService = ApiService();
    String currentDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";

    return await apiService.totalExpense(currentDate); // ใช้ปีและเดือนปัจจุบัน// ดึงข้อมูลยอดขาย ต้นทุน กำไร

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
                      builder: (context) => SummaryFoods()),
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
                FutureBuilder<TotalExpense>(
                  future: _totalExpenseFuture, // ใช้ Future ของ TotalExpense
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      TotalExpense totalExpense = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _buildSummaryCard('ยอดขาย', totalExpense.totalSales.toString())),
                          SizedBox(width: 10),
                          Expanded(child: _buildSummaryCard('ต้นทุน', totalExpense.totalExpense.toString())),
                          SizedBox(width: 10),
                          Expanded(child: _buildSummaryCard('กำไร', totalExpense.totalProfit.toString())),
                        ],
                      );
                    } else {
                      return Center(child: Text('ไม่พบข้อมูลยอดขาย'));
                    }
                  },
                ),
                SizedBox(height: 60),
                Text(
                  'เมนูฮิตประจำเดือนนี้',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FutureBuilder<List<MenuQty>>(
                  future: _menuListFuture, // ใช้ future ที่ได้จาก fetchData
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      List<MenuQty> menuList = snapshot.data!;
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.all(color: Colors.black45),
                            columnWidths: {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'เมนู',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'จำนวน',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              for (var menu in menuList)
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(menu.menuName),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(menu.totalQuantity.toString()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Text(
                        'ไม่มีรายการสั่งอาหาร', style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54
                      ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างการ์ดสรุปยอด
  Widget _buildSummaryCard(String title, String amount) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100], // สีพื้นหลังของการ์ด
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            // ดึงปีและเดือนปัจจุบันในรูปแบบ 'YYYY-MM'
            "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}