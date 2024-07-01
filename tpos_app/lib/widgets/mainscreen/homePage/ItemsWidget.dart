import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/pages/mainscreen/ItemPage.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/user_service.dart';

class ItemsWidget extends StatefulWidget {
  final List<dynamic> listData;
  final Function()? getDataFromWidget;
  ItemsWidget({
    required this.listData,
    this.getDataFromWidget
  });
  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget>{

  void _addToCart(int productId) async {
    ApiResponse response = await addToCart(productId);
    if(response.error == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.data}'),
          )
        );
        widget.getDataFromWidget?.call();
          // Navigator.pushNamed(context, 'mainPage');
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
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return GridView.count(
      childAspectRatio: 0.68,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for(var items in widget.listData)
        Container(
          padding: EdgeInsets.only(left: 15,right: 15,top:15),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ItemPage(
                    title: items.product_name,
                    product:items,
                  )));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    items.imagepath.toString(),
                    height: 100,
                    width: 160,
                    fit:BoxFit.cover
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ItemPage(
                    title: items.product_name,
                    product:items,
                  )));
                },
                child: Container(
                  // padding: EdgeInsets.only(bottom: 1),
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      items.product_name.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(111, 78, 55, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  width: 150,
                  child: Text(
                    items.description == null ? '' : items.description.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(111, 78, 55, 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items.dolarprice.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(111, 78, 55, 1),
                      ),
                    ),
                    kIconButton(Icons.shopping_cart_checkout,(){
                      _addToCart(items.id);
                    },fColor: Colors.white,btnColor: Color.fromRGBO(111, 78, 55, 1),fSize: 19)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
} 