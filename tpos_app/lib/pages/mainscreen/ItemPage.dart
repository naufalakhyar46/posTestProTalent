import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/product.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/user_service.dart';

// ignore: must_be_immutable
class ItemPage extends StatefulWidget{
  final Product? product;
  final String? title;
  ItemPage({this.title,this.product});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage>{

  List<Color> Clrs = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.orange,
  ];

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

  void _addToCart(int? productId) async {
    ApiResponse response = await addToCart(productId);
    if(response.error == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.data}'),
          )
        );
         _getCart();
     }else if(response.error == unauthorized){
        logout().then((value)=>{
          Navigator.pushNamed(context, 'login')
        });
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
    _getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            widget.title.toString(),
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
      backgroundColor: Color(0xFFEDECF2),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Image.network(
              widget.product!.imagepath.toString(),
              height: 400,
              width: 350,
              fit:BoxFit.cover
              ),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 48,bottom: 15),
                      child: Row(
                        children: [
                          Text(
                            widget.product!.product_name.toString(),
                            style: TextStyle(
                              fontSize: 28,
                              color: Color.fromRGBO(111, 78, 55, 1),
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.product!.description == null ? '' : widget.product!.description.toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromRGBO(111, 78, 55, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
      padding: EdgeInsets.all(2),
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3)
            )
          ] 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.product!.dolarprice.toString(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(111, 78, 55, 1),
              ),
            ),
            ElevatedButton.icon(
              onPressed: (){
                _addToCart(widget.product!.id);
              }, 
              icon: Icon(
                CupertinoIcons.cart_badge_plus,
                color: Colors.white,
              ),
              label: Text(
                "Add To Cart",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color.fromRGBO(111, 78, 55, 1)),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                )
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}