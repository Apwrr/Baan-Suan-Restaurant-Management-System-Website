import 'package:flutter/material.dart';
import 'package:animation_2/components/price.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/models/Menu.dart';
import 'components/cart_counter.dart';

class Details_Menu extends StatefulWidget {
  const Details_Menu({
    Key? key,
    required this.menu,
    required this.onProductAdd,
  }) : super(key: key);

  final Menu menu;
  final Function(int, String) onProductAdd;

  @override
  _Details_MenuState createState() => _Details_MenuState();
}

class _Details_MenuState extends State<Details_Menu> {
  String _cartAdd = "";
  int quantity = 1; // จำนวนสินค้าเริ่มต้น
  TextEditingController remark = TextEditingController();

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.37,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              color: Color(0xFFF8F8F8),
                              child: Hero(
                                tag: widget.menu.nameTh ?? 'defaultTag' + _cartAdd,
                                child: Image.asset(widget.menu.imagePath ?? 'assets/images/default.png'),
                              ),
                            ),
                            Positioned(
                              bottom: -20,
                              child: CartCounter(
                                onIncrement: () => increment(),
                                onDecrement: () => decrement(),
                                quantity: quantity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: defaultPadding * 1.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.menu.nameTh ?? 'ชื่อเมนู',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Price(amount: widget.menu.price ?? 0),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: remark,
                            decoration: InputDecoration(
                              hintText: 'ช่องเขียนเพิ่มเติม',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: defaultPadding), // ระยะห่างเพิ่มเติม
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onProductAdd(quantity, remark.text);
                    setState(() {
                      _cartAdd = '_cartAdd';
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE4F0E6), // กำหนดสีปุ่มเป็น E4F0E6
                  ),
                  child: Text(
                    "เพิ่มลงตะกร้า",
                    style: TextStyle(color: Colors.black), // กำหนดสีตัวหนังสือในปุ่มเป็นสีดำ
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(
        color: Colors.black,
      ),
      backgroundColor: Color(0xFFE4F0E6), // กำหนดสีของ AppBar เป็น E4F0E6
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Food",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
