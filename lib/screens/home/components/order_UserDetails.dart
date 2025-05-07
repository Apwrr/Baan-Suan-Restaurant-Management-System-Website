import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/components/price.dart';
import 'package:animation_2/screens/deatils/components/cart_counter.dart';
import '../../../models/ProductItem.dart';

// ignore: camel_case_types
class Order_UserDetails extends StatefulWidget {
  const Order_UserDetails({
    Key? key,
    required this.productItem,
    required this.controller,
    required this.onRemove,
  }) : super(key: key);

  final ProductItem productItem;
  final HomeController controller;
  final VoidCallback onRemove;

  @override
  _Order_UserDetailsState createState() => _Order_UserDetailsState();
}

class _Order_UserDetailsState extends State<Order_UserDetails> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.productItem.quantity;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    widget.controller.updateProductQuantity(widget.productItem, _quantity);
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      widget.controller.updateProductQuantity(widget.productItem, _quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(widget.productItem.menu.imagePath!),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.productItem.menu.nameTh!,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          if (widget.productItem.remark.isNotEmpty) // แสดง note ถ้ามีค่า
            Text(
              'เพิ่มเติม: ${widget.productItem.remark}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Row(
              children: [
                Price(amount: widget.productItem.menu.price!),
                SizedBox(width: 10),
                CartCounter(
                  quantity: _quantity,
                  onIncrement: _incrementQuantity,
                  onDecrement: _decrementQuantity,
                  buttonSize: 30.0, // กำหนดขนาดปุ่มใน Order_UserDetails
                  iconSize: 16.0, // กำหนดขนาดไอคอนใน Order_UserDetails
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              widget.controller.removeProductFromCart(widget.productItem);
              widget.onRemove();
            },
          ),
        ],
      ),
    );
  }
}
