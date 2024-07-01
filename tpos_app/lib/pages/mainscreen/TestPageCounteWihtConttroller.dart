import 'package:flutter/material.dart';
import 'package:tpos_app/controllers/TestCounter.dart';
import 'package:tpos_app/widgets/mainscreen/ItemTestCounter.dart';
import 'package:get/get.dart';

class TestPageCounteWihtConttroller extends StatelessWidget{
  final TestCounter _TestCounter = Get.put(TestCounter());
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListView(
              shrinkWrap: true,
              children: 
                List.generate(5,
                  (i) => ItemTestCounter(
                          title: "Produk #$i",
                          price: 50,
                  )
                )
            ),
            ElevatedButton(
              onPressed: (){}, 
              child: Obx(() => Text('Total Payment : '+_TestCounter.total.value.toString(),
                style: TextStyle(fontSize: 20,color: Colors.white),
              ))
              )
          ],
        ),
      )
    );
  }
}