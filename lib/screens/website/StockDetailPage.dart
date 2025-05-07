import 'package:animation_2/models/ExpenseItem.dart';
import 'package:animation_2/screens/website/home.dart';
import 'package:flutter/material.dart';

class StockDetailPage extends StatelessWidget {
  final List<ExpenseItemSimple> expenseItems;

  const StockDetailPage({Key? key, required this.expenseItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  'รายละเอียดสต๊อก',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenseItems.length,
                    itemBuilder: (context, index) {
                      final item = expenseItems[index];
                      return ListTile(
                        title: Text(item.detail, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('จำนวน: ${item.qty} ${item.unit ?? ''}',style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('ราคา: ฿ ${item.total.toStringAsFixed(2)} บาท',style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
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
