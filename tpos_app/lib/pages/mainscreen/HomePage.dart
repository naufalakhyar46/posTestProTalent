import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/product.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/product_service.dart';
import 'package:tpos_app/services/user_service.dart';
import 'package:tpos_app/widgets/mainscreen/homePage/CategoriesWidget.dart';
import 'package:tpos_app/widgets/mainscreen/homePage/ItemsWidget.dart';
import 'package:badges/badges.dart' as badges;

String? valueSearch = '';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool loading = true;
  List<dynamic> _listData = [];
  int page = 1;
  bool lastPage = false;
  AllProduct? allProduct;
  var scrollController = ScrollController();

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

  void retrieveData() async {
    ApiResponse response = await getProduct(page, valueSearch);
    if(response.error == null){
        allProduct = response.data as AllProduct;
        setState(() {
          final json = allProduct!.query as List<dynamic>;
          _listData = _listData + json;
          if(json.length == 0){
            lastPage = true;
          }
          loading = false;
        });
     }else if(response.error == unauthorized){
        logout().then((value)=>{
          navigatorKey.currentState?.pushNamed('login')
        });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        )
      );
    }
  }

  void getDataScroll(ScrollController val) async {
    setState(() {
      scrollController = val;
    });
  }

  void getDataFromWidget(String val) async{
    setState(() {
        loading = true;
        valueSearch = val;
        lastPage = false;
        page = 1;
        _listData = [];
      });
        retrieveData();
        _getCart();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      lastPage = false;
      page = 1;
      _listData = [];
    });
      _getCart();
      retrieveData();
  }

  void _scrollListener(){
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        loading = true;
        if(!lastPage){
            page = page + 1;
        }
        retrieveData();
    }
  }
  
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = false;
    });
    _getCart();
    scrollController.addListener(_scrollListener);
    retrieveData();
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation:0,
          title: Text(
            'Produk',
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
          color: Color(0xFFEDECF2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
            userRole == 1 ? Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 150,
                child: kTextButtonGoToDashboard(
                  'Go to dashboard',
                  (){
                    Navigator.pushNamed(context, 'admin/main-dashboard');
                  },
                  fSize: 15,
                  btnColor: Color.fromRGBO(111, 78, 55, 1),
                  )
              ),
            ) : SizedBox(),
            Container(
              padding: EdgeInsets.only(top:15,bottom: 15),
              decoration: BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )
              ),
              child: Column(
                
                children:[
          
                  // Categories Widget
                  CategoriesWidget(getDataFromWidget: getDataFromWidget),
          
                  SizedBox(height: 20,),
          
                  // Items Widget
                  ItemsWidget(listData:_listData,getDataFromWidget:_getCart),
                ]
              ),
            )
          ],
          ),
        ),
      ),
      bottomNavigationBar: kNavigate(0),
    );
  }
}