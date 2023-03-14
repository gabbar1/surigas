import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view_model/expense_vm/expense_vm.dart';

class Expanse extends StatefulWidget {
  const Expanse({Key? key}) : super(key: key);

  @override
  State<Expanse> createState() => _ExpanseState();
}

class _ExpanseState extends State<Expanse> {
  final _globalFistKey = GlobalKey<FormState>();
  ExpenseVM expenseVM = Get.put(ExpenseVM());
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseNameController = TextEditingController();
  DateTime? _startDateTime = DateTime.now();
  DateTime? _endDateTime = DateTime.now();
  String? startDate;
  String? endDate;
  void _showDatePicker() async{
    _startDateTime = await
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime.now());
    if (_startDateTime == null){
      return;
    }else{
      setState(() {
        startDate = "${_startDateTime!.day}/${_startDateTime!.month}/${_startDateTime!.year}";
        print("Date$startDate");
      });
    }

  }
  void _showDatePicker1() async{
    _endDateTime = await
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2030));
    if (_endDateTime == null){
      return;
    }else{
      setState(() {
        endDate = "${_endDateTime!.day}/${_endDateTime!.month}/${_endDateTime!.year}";
        print("Date$endDate");
        expenseVM.fetchExpenseListWithDate(_startDateTime!,_endDateTime);
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    expenseVM.fetchExpenseList(false);
    super.initState();
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        suffixIcon: InkWell(
                            onTap:_showDatePicker,
                            child: Icon(Icons.calendar_month_outlined )),
                        hintText: startDate==null ?"Pick a Date":startDate.toString(),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17.0),)
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(

                        suffixIcon: InkWell(
                            onTap:_showDatePicker1,
                            child: Icon(Icons.calendar_month_outlined )),
                        hintText: endDate==null?"Pick a Date":endDate.toString(),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17.0),)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 25,right: 20),
              child: Column(
                children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Total",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                     SizedBox(width: 0,),
                     Text("Expense",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                     SizedBox(width: 130,),
                     Row(children: [
                       Icon(Icons.currency_rupee),
                       //Text("12000",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),909c
                       SizedBox(width: 10,),
                     ],)
                   ],
                 ),
                ],
              ),
            ),
            Expanded(child:Obx(() =>ListView.separated(
              itemCount: expenseVM.getExpenseList.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: ((context,index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20,left: 10,bottom: 20,top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                              Text(expenseVM.getExpenseList[index].expenseName.toString(),style: TextStyle(fontSize: 20),),
                              Text(expenseVM.getExpenseList[index].expenseAmount.toString(),style: TextStyle(fontSize: 20),),

                            ],
                          ),
                      Text(DateTime.parse(expenseVM.getExpenseList[index]!.date!.toDate().toString()).toString()),
                    ],
                  ),
                );
              }),
            )))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddExpenseDialog();
        },
        child: Icon(Icons.add),
      ),

    );
  }
  Future<void> showAddExpenseDialog() async{
     return showModalBottomSheet(
         isScrollControlled: true,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.only(
               topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
         ),
         context: Get.context!, builder: (BuildContext context) {
           return Padding(padding: EdgeInsets.all(15),

             child:Form(
                 key: _globalFistKey,
                 child: Column(
               children: [
                 SizedBox(height: 50,
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Text("Add",style: TextStyle(fontSize: 20),),
                       SizedBox(width: 10,),
                       Text("Expense",style: TextStyle(color: Colors.blue,fontSize: 20,),),

                       ],
                     ),
                     Align(alignment: Alignment.topRight,
                     child: IconButton(
                       icon:Icon(Icons.clear_rounded),onPressed: ()=>Navigator.of(context).pop(),),)
                   ],
                 ),
                 /*InkWell(
                   onTap: _showDatePicker,
                   child: Container(
                     padding: EdgeInsets.only(left: 10,right: 10),
                     height: 60,
                     child: Center(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Obx(()=>Text(customerPageVM.getStartDate)),

                             Icon(Icons.arrow_drop_down),
                           ],
                         )),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                       color: Color(0xFFF2F2F2),
                     ),
                   ),
                 ),*/
                 TextFormField(
                   textInputAction: TextInputAction.next,
                   controller: expenseNameController,
                   decoration: InputDecoration(
                     hintText: "Name of Expense",
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20.0))),
                   validator: (value){
                     if (value!.isEmpty){
                       return "Field is required";
                     }
                     return null;
                   },
                 ),
                 SizedBox(height: 10,),
                 TextFormField(
                   controller: expenseAmountController,
                   keyboardType: TextInputType.number,
                   decoration: InputDecoration(
                     hintText: "Amount",
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20.0)
                     )
                   ),
                   validator: (value){
                     if (value!.isEmpty){
                       return "Field is required";
                     }
                     return null;
                   },
                 ),
                 SizedBox(height: 20,),
                 InkWell(
                   onTap: (){
                     if(_globalFistKey.currentState!.validate()){
                       expenseVM.addExpense(expenseNameController.text, num.parse(expenseAmountController.text,)).then((value) {expenseNameController.clear();
                       expenseAmountController.clear();});
                     }
                   },
                   child: Container(
                     padding: EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: Colors.blue,
                       borderRadius: BorderRadius.circular(10),
                       border: Border.all(color: Colors.grey.shade500)
                     ),
                     child: Center(
                       child: Text("Submit",style: TextStyle(color: Colors.white),),
                     ),
                   ),
                 )
               ],
             )));
       
     });
  }
}
