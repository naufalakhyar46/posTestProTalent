import 'package:flutter/material.dart';
import 'package:tpos_app/controllers/TestCounter.dart';
import 'package:get/get.dart';

class ItemTestCounter extends StatefulWidget{
  ItemTestCounter({required this.title, required this.price});

  final String title;
  final int price;
  @override
  _CartItemState createState() => _CartItemState(); 
}

class _CartItemState extends State<ItemTestCounter>{
  final TestCounter _TestCounter = Get.find();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: new Text(
          widget.title,
          style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 200,
          child: Wrap(alignment: WrapAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                counter != 0 ?
                new IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      counter--;
                      _TestCounter.decrement(widget.price);
                    });
                  },
                )
                : Container(),
                Text(
                  "$counter",
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      counter++;
                      _TestCounter.increment(widget.price);
                    });
                  },
                ),
              ],
            )
          ],
          ),
        ),
      ),
    );
  }
}