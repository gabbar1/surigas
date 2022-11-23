import 'package:flutter/material.dart';

class Expanse extends StatefulWidget {
  const Expanse({Key? key}) : super(key: key);

  @override
  State<Expanse> createState() => _ExpanseState();
}

class _ExpanseState extends State<Expanse> {
  DateTime _dateTime = DateTime.now();
  void _showDatePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2025));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("Expense"),
        actions: [
          Center(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Align(
                      child: Icon(
                    Icons.add_chart,
                    color: Colors.blue,
                  )),
                ),
                Text(
                  "Download",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.date_range,color: Colors.black,),
                  suffixIcon: InkWell(
                      onTap:_showDatePicker,
                      child: Icon(Icons.calendar_view_month)),
                  hintText: _dateTime.toString(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17.0))
              ),
            ),
          ],
        ),
      ),
    );
  }
}
