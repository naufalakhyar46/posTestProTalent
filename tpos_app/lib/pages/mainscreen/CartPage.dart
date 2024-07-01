import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/order.dart';
import 'package:tpos_app/pages/mainscreen/orderDetailPage.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget{
  @override
  _CartPageState createState() => _CartPageState();
}
class _CartPageState extends State<CartPage>{
  bool loading = false;
  List<dynamic> _listData = [];
  final oCcy = NumberFormat("#,##0.00", "en_US");
  num valPrice = 0;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController
  nameCustomerController = TextEditingController();
  
  Future<void> _getCart() async {
    ApiResponse response = await getCart();
    if(response.error == null){
      setState(() {
        var json = response.data as List;
        _listData = json;
        calculatePrice();
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        )
      );
    }
  }

  void _destroyCart(int cartId) async {
    ApiResponse response = await destroyCart(cartId);
    if(response.error == null){
      _getCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.data}'),
        )
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        )
      );
    }
  }

  void calculatePrice() {
    valPrice = 0; 
    for(var items in _listData){
      valPrice += items.product.price*items.qty;
    }
    setState(() {
      valPrice = valPrice;
    });
  }

  void _goCheckout() async{
    var order = jsonEncode(<String, dynamic>{
      'customer_name': nameCustomerController.text,
      'total_price': valPrice.toString(),
      'order_detail':[
        for(var items in _listData)
        {
          'product_id':items.product_id.toString(),
          'product_name':items.product.product_name,
          'qty':items.qty.toString(),
          'price':items.product.price.toString(),
          'per_total_price':(items.product.price * items.qty).toString()
        }
      ]
    });
    ApiResponse response = await checkout(order);
    if(response.error == null){
        var dt = response.data as Map<String, dynamic>;
      _getCart();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${dt['message']}'),
          )
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailOrderPage(
          order: Order.fromJson(dt['data']),
        )));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        )
      );
    }
  }

  @override
  void initState(){
    super.initState();
    _getCart();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Color.fromRGBO(111, 78, 55, 1)),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pushNamed(context, 'mainPage');
            },
          ),
          scrolledUnderElevation:0,
          title: Text(
            "Cart",
            style: TextStyle(
              color: Color.fromRGBO(111, 78, 55, 1),
              fontSize: 23,
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
        onRefresh:_getCart,
        child: ListView(
          children: [
        
            Container(
              // Temporary height
              height: 800,
              padding: EdgeInsets.only(top:15),
              decoration: BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                )
              ),
              child: Column(children: [
                Column(
                    children: [
                      for(var items in _listData)
                      Container(
                        height: 110,
                        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Radio(
                                value: "", 
                                groupValue: "", 
                                activeColor: Color.fromRGBO(111, 78, 55, 1), 
                                onChanged: (index){},
                            ),
                            Container(
                              height: 70,
                              width: 70,
                              margin: EdgeInsets.only(right: 15),
                              child: Image.network(
                                  items.product.imagepath.toString(),
                                  fit:BoxFit.cover
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:110,
                                    child: Text(
                                      items.product.product_name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(111, 78, 55, 1),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    items.product.dolarprice.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(111, 78, 55, 1),
                                    ),
                                  )
                                ],
                              ),
                            ),
        
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      _destroyCart(items.id);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          setState(() {
                                            items.qty > 1 ? items.qty-- : _destroyCart(items.id);
                                          });
                                            calculatePrice();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              )
                                            ]
                                          ),
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          items.qty.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(111, 78, 55, 1),
                                            ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            items.qty++;
                                          });
                                          calculatePrice();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              )
                                            ]
                                          ),
                                          child: Icon(
                                            CupertinoIcons.plus,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: formkey,
                        child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: kInputDecoration('Customer Name'),
                                controller: nameCustomerController,
                                validator: (val) => val!.isEmpty ? 'Invalid Customer Name' : null,
                              ),
                            ),
                          ),
                      )
                    ],
                  ),
              ],),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
      height: 130,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(
                    color: Color.fromRGBO(111, 78, 55, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  '\$'+oCcy.format(valPrice).toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ]
            ),
            kTextButton("Check Out", (){
               if(_listData.length == 0){
                return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order Required'),
                          )
                        );
               }
               if(formkey.currentState!.validate()){
                  setState(() {
                    loading = true;
                  });
                  _goCheckout();
                }
            },
            btnColor: Color.fromRGBO(111, 78, 55, 1),
            fSize: 18,
            btnPadding: EdgeInsets.symmetric(vertical: 5,horizontal:130)
            ),
            // Container(
            //   alignment: Alignment.center,
            //   height: 50,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Color.fromRGBO(111, 78, 55, 1),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Text(
            //     "Check Out",
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
    );
  }
}