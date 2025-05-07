import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/home/components/order_status.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/screens/home/components/order_User.dart';
import '../../../constants.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key, required this.controller, required this.table}) : super(key: key);

  final HomeController controller;
  final int? table;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.shopping_cart,
          color: Colors.green[200],
          size: 30.0, // สีของไอคอนตะกร้า
        ),

        const SizedBox(width: defaultPadding),

        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_User(controller: controller, table: table)),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFE4F0E6),
              side: BorderSide(
                color: Colors.grey, // สีของเส้นกรอบ
                width: 1, // ความหนาของเส้นกรอบ
              ),
            ), // สีของปุ่ม
            child: Text(
              "ดูเมนูในตะกร้า",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              controller.totalCartItems().toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[300]),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderStatus(controller: controller, table: table),
                      ),
                    ).then((value) {
                      // ตรวจสอบชนิดของ value และไม่ให้รีเซ็ต orderItems ตามเงื่อนไข
                      if (value != null && value is OrderStatus) {
                        // ไม่มีการเปลี่ยนแปลง orderItems ในกรณีนี้
                      }
                    });
                  },
                  icon: Icon(
                    Icons.content_paste,
                    color: Colors.black, // สีของไอคอนตะกร้า
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
