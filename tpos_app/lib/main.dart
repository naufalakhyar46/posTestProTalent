import 'package:flutter/material.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/pages/auth/login.dart';
import 'package:tpos_app/pages/dashboard/mainDashboard.dart';
import 'package:tpos_app/pages/dashboard/orderDashboard.dart';
import 'package:tpos_app/pages/dashboard/productDashboard.dart';
import 'package:tpos_app/pages/dashboard/productFormDashboard.dart';
import 'package:tpos_app/pages/dashboard/userDashboard.dart';
import 'package:tpos_app/pages/loading.dart';
import 'package:tpos_app/pages/mainscreen/CartPage.dart';
import 'package:tpos_app/pages/mainscreen/HomePage.dart';
import 'package:tpos_app/pages/mainscreen/Itempage.dart';
import 'package:tpos_app/pages/mainscreen/TestPageCounteWihtConttroller.dart';
import 'package:tpos_app/pages/mainscreen/TestPageCounter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tpos_app/pages/mainscreen/changePasswordPage.dart';
import 'package:tpos_app/pages/mainscreen/changeProfilePage.dart';
import 'package:tpos_app/pages/mainscreen/orderPage.dart';
import 'package:tpos_app/pages/mainscreen/profilePage.dart';
import 'package:tpos_app/services/order_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
int? userRole;
int? totalCartGlobal;
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return ScreenUtilInit(
      designSize: Size(375,812),
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Loading(),
        routes: {
          "login" : (context) => Login(),
          "mainPage" : (context) => HomePage(),
          "orderPage" : (context) => OrderPage(),
          "profilePage" : (context) => ProfilePage(),
          "changePassword" : (context) => ChangePasswordPage(),
          "changeProfile" : (context) => ChangeProfilePage(),
          "cartPage" : (context) => CartPage(),
          "itemPage" : (context) => ItemPage(),
          "testPage" : (context) => TestPageCounter(),
          "testPage2" : (context) => TestPageCounteWihtConttroller(),
          "admin/main-dashboard" : (context) => MainDashboardPage(),
          "admin/product" : (context) => ProductDashboardPage(),
          "admin/product-form" : (context) => ProductFormDashboardPage(),
          "admin/user" : (context) => UserDashboardPage(),
          "admin/user-form" : (context) => MainDashboardPage(),
          "admin/order" : (context) => OrderDashboardPage(),
        },
      ),
    );
  }
}

