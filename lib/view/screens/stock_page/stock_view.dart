import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surigas/view_model/stock_view_model/stock_view_model.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  StockViewModel stockViewModel = Get.put(StockViewModel());

  @override
  void initState() {
    // TODO: implement initState
    stockViewModel.fetStockList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text("Stock"),
        actions: [
          Row(
            children: [
              Icon(Icons.file_download_outlined,color:(Colors.blue),),
              SizedBox(width: 5,),
              Text("Download")
            ],
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10,right: 0,left: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Type",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Row(children: [
                        Text("Full",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(width: 45,),
                        Text("empty",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      ],)
                    ],
                  ),
                ],
              )


            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Obx(()=>ListView.separated(itemCount: stockViewModel.getStockList.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(stockViewModel.getStockList[index].key.toString(),style: TextStyle(fontSize: 20)),

                    Row(children: [
                      Text(stockViewModel.getStockList[index].pendingCylinder.toString(),style: TextStyle(fontSize: 20),),
                      SizedBox(width: 80,),
                      Text(stockViewModel.getStockList[index].emptyCylinder.toString(),style: TextStyle(fontSize: 20),),
                      SizedBox(height: 50,),
                    ],)
                  ],

                );

              },)),
            ))
          ],
        ),
      ),
    );
  }
}
