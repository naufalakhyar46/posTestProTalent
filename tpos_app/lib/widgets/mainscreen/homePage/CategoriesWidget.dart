import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesWidget extends StatefulWidget{
  CategoriesWidget({this.getDataFromWidget});
  final Function(String val)? getDataFromWidget;
  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget>{
  List<Map<String, dynamic>> varCategory = [
    {
      'name':'All',
      'value':'',
      'image':null
    },
    {
      'name':'Drink',
      'value':'drink',
      'image':'drink.png'
    },
    {
      'name':'Food',
      'value':'food',
      'image':'food.png'
    }
  ];
  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for(var items in varCategory)
            Card(
              color: Colors.white,
              child: InkWell(
                onTap: (){widget.getDataFromWidget?.call(items['value']);},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: items['image'] == null ? EdgeInsets.symmetric(vertical: 13,horizontal: 40) : EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: InkWell(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // use i variable to change picture in loop
                        items['image'] == null ? SizedBox() : Image.asset("assets/${items['image']}", 
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          "${items['name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color.fromRGBO(111, 78, 55, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}