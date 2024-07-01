import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/order.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

class DetailOrderPage extends StatefulWidget{
  final Order? order;

  DetailOrderPage({
    this.order,
  });

  @override
  _DetailOrderPageState createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  bool loading = false;
  Order? order_data;
  List<DetailOrder>? orderDetail;
  String? txtOrderStatus;
  final oCcy = NumberFormat("#,##0.00", "en_US");

  void _getCart() async {
    ApiResponse response = await getCart();
    if(response.error == null){
      setState(() {
        var json = response.data as List;
        totalCartGlobal = json.length;
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        )
      );
    }
  }

  void _handlePaidOrder(int? orderId) async {
    ApiResponse response = await orderPaid(orderId);
    if(response.error == null){
      setState(() {
        order_data = response.data as Order;
        getProductStatus();
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${txtOrderStatus}'),
      ));
    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.pushNamed(context, 'login')
      });
    }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
    }
  }
  void _handleCancelOrder(int? orderId) async {
    ApiResponse response = await orderCancel(orderId);
    if(response.error == null){
      setState(() {
        order_data = response.data as Order;
        getProductStatus();
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${txtOrderStatus}'),
      ));
    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.pushNamed(context, 'login')
      });
    }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
    }
  }
  
  void getProductStatus(){
    setState(() {
      if(order_data?.product_status == 'paid'){
        txtOrderStatus = 'Order Paid';
      }else if(order_data?.product_status == 'unpaid'){
        txtOrderStatus = 'Order Unpaid';
      }else{
        txtOrderStatus = 'Order Cancelled';
      }
    });
  }
  Future<void> _handleRefresh() async {
    setState(() {
      loading = false;
    });
    getProductStatus();
  }

  @override
  void initState(){
    setState(() {
      order_data = widget.order!;
      orderDetail = widget.order?.order_detail as List<DetailOrder>;
      loading = false;
    });
    _getCart();
    getProductStatus();
    super.initState();
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
                Navigator.pushNamed(context, 'orderPage');
            },
          ),
          scrolledUnderElevation:0,
          title: Text(
            order_data!.order_code.toString(),
            style: TextStyle(
              color: Color.fromRGBO(111, 78, 55, 1),
              fontSize: 23,
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            Center(
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top:2,end: 1),
                badgeAnimation: badges.BadgeAnimation.slide(
                  animationDuration: Duration(milliseconds: 300),
                ),
                badgeContent: Text(
                  '${totalCartGlobal}',
                  style: TextStyle(color: Colors.white),
                ),
                child:
                IconButton(
                  icon: Icon(
                          Icons.shopping_bag_outlined,
                          size: 32,
                          color: Color.fromRGBO(111, 78, 55, 1),
                        ), 
                  onPressed: () {
                    Navigator.pushNamed(context, "cartPage");
                  }
                ),
              ),
          ),
          SizedBox(width: 10,),
          ],
        ),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Container(
        decoration: BoxDecoration(
            color: Color(0xFFEDECF2)
        ),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: order_data!.product_status == 'paid' ? Colors.green[400] : Colors.white
                      ),
                      child: order_data!.product_status == 'paid' ? 
                             Text(txtOrderStatus.toString(),style: TextStyle(color: Colors.white,fontSize: 20)) :
                             Text(txtOrderStatus.toString(),style: TextStyle(color: Colors.red[400],fontSize: 20)) 
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('Order Code',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text(order_data!.order_code.toString()),
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('Customer Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text(order_data!.customer_name.toString()),
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('Date Order',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text(order_data!.created_date.toString()),
                            ])
                          ],
                        ),
                      )
                    ),
                    for(var items in orderDetail!)
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Image(
                                    height: 60,
                                    width: 60,
                                    image: NetworkImage(items.product!.imagepath.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        width: 270,
                                        child: Text(
                                          items.product_name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 15),
                                          ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 280,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('\$'+oCcy.format(items.price).toString()),
                                            Text('x'+items.qty.toString()),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 0.5,
                              color: Colors.black26,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('\$'+oCcy.format(items.per_total_price).toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('Total Price',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              Text('\$'+oCcy.format(order_data!.total_price).toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                            ])
                          ],
                        ),
                      )
                    ),
                    order_data!.product_status != 'unpaid' ? SizedBox() : Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          kTextButton('Cancelled', (){loading=true;_handleCancelOrder(order_data!.id);},btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 55),btnColor: Colors.red[400] as Color),
                          kTextButton('Paid', (){loading=true;_handlePaidOrder(order_data!.id);},btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 70),btnColor: Colors.green[400] as Color),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: kNavigate(1),
    );
  }
}