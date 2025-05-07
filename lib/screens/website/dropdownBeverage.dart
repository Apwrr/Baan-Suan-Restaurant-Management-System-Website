import 'package:animation_2/screens/website/expenseItems.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API requests
import 'package:animation_2/models/ExpenseItem.dart';

class AddNewItem3 extends StatefulWidget {
  final Function(ExpenseItem) onItemAdded;
  final Function(ExpenseItem) onItemRemoved;

  final TextEditingController nameController = TextEditingController();
  double? qtyController;
  double? priceController;
  final TextEditingController unitController = TextEditingController();

  AddNewItem3({required this.onItemAdded, required this.onItemRemoved, Key? key3}) : super(key: key3);

  @override
  AddNewItem3State createState() => AddNewItem3State();
}

class AddNewItem3State extends State<AddNewItem3> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  String? selectedIngredient;
  List<dynamic> beverageList = []; // Data list for ingredients
  int? selectedIngredientId;

  @override
  void initState() {
    super.initState();
    fetchIngredient(); // Fetch ingredients when the widget is initialized
  }

  Future<void> fetchIngredient() async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/menu-list/5'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      setState(() {
        beverageList = jsonResponse;
      });
    } else {
      throw Exception('Error fetching ingredients!');
    }
  }

  void saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final expenseItem = ExpenseItem(
        id: 0,
        detail: widget.nameController.text,
        qty: widget.qtyController ?? 0,
        total: widget.priceController ?? 0.0,
        unit: widget.unitController.text,
        menuId: selectedIngredientId,
      );

      print('ExpenseItem test: ${json.encode(expenseItem.toJson())}');
      widget.onItemAdded(expenseItem); // ส่งข้อมูล ExpenseItem กลับไปยัง StockDetails

      _clearFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ถูกต้อง')),
      );
    }
  }

  void _clearFields() {
    widget.nameController.clear();
    widget.qtyController = null;
    widget.priceController = null;
    widget.unitController.clear();
    selectedIngredient = null;
    selectedIngredientId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Assign the form key
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อรายการ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: beverageList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('วัตถุดิบ'),
                      value: selectedIngredient,
                      items: beverageList.map((ingredient) {
                        return DropdownMenuItem<String>(
                          value: ingredient['id'].toString(),
                          child: Text(ingredient['nameTh']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedIngredient = newValue;
                          final selectedIngredientData = beverageList.firstWhere(
                                  (ingredient) => ingredient['id'].toString() == newValue);
                          widget.nameController.text = selectedIngredientData['nameTh'];
                          selectedIngredientId = int.tryParse(newValue ?? '');
                        });
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
                Text('ยอดเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      initialValue: widget.priceController?.toString(),
                      decoration: InputDecoration(
                        hintText: 'ราคา',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกยอดเงิน';
                        } else if (double.tryParse(value) == null) {
                          return 'กรุณากรอกตัวเลขเท่านั้น';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          widget.priceController = double.tryParse(value) ?? 0.0;
                        });
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
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      initialValue: widget.qtyController?.toString(),
                      decoration: InputDecoration(
                        hintText: 'จำนวน',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกจำนวน';
                        } else if (double.tryParse(value) == null) {
                          return 'กรุณากรอกตัวเลขเท่านั้น';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          widget.qtyController = double.tryParse(value) ?? 0;
                        });
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
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('หน่วย'),
                      value: widget.unitController.text.isNotEmpty ? widget.unitController.text : null,
                      items: ['ขวด', 'กระป๋อง'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          widget.unitController.text = newValue ?? '';
                        });
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
                  detail: widget.nameController.text,
                  qty: widget.qtyController ?? 0,
                  total: widget.priceController ?? 0.0,
                  unit: widget.unitController.text ?? '',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
