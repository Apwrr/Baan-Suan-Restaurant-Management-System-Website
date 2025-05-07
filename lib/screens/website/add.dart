import 'package:animation_2/screens/website/expenseItems.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:animation_2/models/ExpenseItem.dart';

class AddNewItem extends StatefulWidget {
  final Function(ExpenseItem) onItemAdded;
  final Function(ExpenseItem) onItemRemoved; // ฟังก์ชันสำหรับลบ

  const AddNewItem(
      {Key? keys, required this.onItemAdded, required this.onItemRemoved})
      : super(key: keys);

  @override
  AddNewItemState createState() => AddNewItemState();
}

class AddNewItemState extends State<AddNewItem> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? selectedUnit;

  final _formKey = GlobalKey<FormState>(); // สร้าง GlobalKey สำหรับฟอร์ม

  // Method to save the item and send it back to the parent widget
  void saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newItem = ExpenseItem(
      id: 0,
      detail: nameController.text,
      qty: double.tryParse(qtyController.text) ?? 0,
      total: double.tryParse(priceController.text) ?? 0.0,
      unit: selectedUnit!,
      menuId: null,
      ingredientId: null,
    );

    widget.onItemAdded(newItem);
    //clearFields(); // เคลียร์ข้อมูลเมื่อเพิ่มรายการแล้ว
  }

  // Method to clear the input fields
  void clearFields() {
    nameController.clear();
    qtyController.clear();
    priceController.clear();
    selectedUnit = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // ใช้ฟอร์มสำหรับการตรวจสอบข้อมูล
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อรายการ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'ชื่อรายการ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ยอดเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'ราคา',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || double.tryParse(value) == null) {
                          return 'กรุณาใส่ตัวเลขเท่านั้น';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('จำนวน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'จำนวน',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || double.tryParse(value) == null) {
                          return 'กรุณาใส่ตัวเลขเท่านั้น';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('หน่วย', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('หน่วย'),
                      items: ['กิโลกรัม', 'กรัม', 'ขวด', 'ฟอง', 'กำ', 'ชิ้น', 'ลัง', 'ห่อ', 'ถุง', 'กระป๋อง', 'แพ็ค', 'หลอด', 'คน', 'ถ้วย']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedUnit = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'กรุณาเลือกหน่วย';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              widget.onItemRemoved(
                ExpenseItem(
                  id: 0,
                  detail: nameController.text,
                  qty: double.tryParse(qtyController.text) ?? 0,
                  total: double.tryParse(priceController.text) ?? 0.0,
                  unit: selectedUnit ?? '',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

