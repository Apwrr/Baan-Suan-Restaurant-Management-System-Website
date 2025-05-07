import 'package:animation_2/screens/website/ExpireItems.dart';
import 'package:animation_2/screens/website/expenseItems.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API requests
import 'package:animation_2/models/ExpenseItem.dart';

class AddExpire extends StatefulWidget {
  final Function(ExpireItem) onItemAdded;
  final Function(ExpireItem) onItemRemoved; // ฟังก์ชันสำหรับลบ

  final TextEditingController nameController = TextEditingController();
  double? qtyController;
  double? priceController;
  final TextEditingController unitController = TextEditingController();

  AddExpire({required this.onItemAdded,required this.onItemRemoved, Key? key}) : super(key: key);

  @override
  AddExpireState createState() => AddExpireState();
}

class AddExpireState extends State<AddExpire> {
  String? selectedIngredient;
  List<dynamic> ingredientList = []; // Data list for ingredients
  int? selectedIngredientId;

  final _formKey = GlobalKey<FormState>(); // Global key for the form

  @override
  void initState() {
    super.initState();
    fetchIngredient(); // Fetch ingredients when the widget is initialized
  }

  Future<void> fetchIngredient() async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/ingredient/list'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      setState(() {
        ingredientList = jsonResponse;
      });
    } else {
      throw Exception('Error fetching ingredients!');
    }
  }

  void saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    print('Ingredient ID: $selectedIngredientId');
    print('Quantity: ${widget.qtyController}');
    print('Unit: ${widget.unitController.text}');


    final expireItem = ExpireItem(
      id: 0,
      ingredientId: selectedIngredientId!,
      qty: widget.qtyController ?? 0,
      name: widget.unitController.text,
      unit: widget.unitController.text,
      expiredDate: DateTime.now(),

    );

    print('ExpireItem test: ${json.encode(expireItem.toJson())}');
    widget.onItemAdded(expireItem); // ส่งข้อมูล ExpenseItem กลับไปยัง StockDetails

  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Form key for validation
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อรายการ', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: ingredientList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('วัตถุดิบ'),
                      value: selectedIngredient,
                      items: ingredientList.map((ingredient) {
                        return DropdownMenuItem<String>(
                          value: ingredient['id'].toString(),
                          child: Text(ingredient['name']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedIngredient = newValue;
                          final selectedIngredientData = ingredientList
                              .firstWhere(
                                  (ingredient) =>
                              ingredient['id'].toString() == newValue);
                          widget.nameController.text =
                          selectedIngredientData['name'];
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
                Text('จำนวนหมดอายุ', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
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
                        if (value == null || double.tryParse(value) == null) {
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
                Text('หน่วย', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('หน่วย'),
                      value: widget.unitController.text.isNotEmpty ? widget
                          .unitController.text : null,
                      items: ['กิโลกรัม', 'กรัม', 'ฟอง'].map((String value) {
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
                ExpireItem(
                  id: 0,
                  ingredientId: selectedIngredientId!,
                  qty: widget.qtyController ?? 0,
                  name: widget.unitController.text,
                  unit: widget.unitController.text,
                  expiredDate: DateTime.now(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
