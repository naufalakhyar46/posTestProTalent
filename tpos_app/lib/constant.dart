import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/pages/mainscreen/HomePage.dart';
import 'package:tpos_app/pages/mainscreen/orderPage.dart';
import 'package:tpos_app/pages/mainscreen/profilePage.dart';

const baseURL = 'http://192.168.0.107:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/me';
const productURL = baseURL + '/product';
const cartURL = baseURL + '/cart';
const orderURL = baseURL + '/order';

// Errors
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// const arrPage = ['mainPage','orderPage','profilePage'];
var arrPage = [HomePage(),OrderPage(),ProfilePage()];




Container kItemProfile(String label,dynamic value){
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${label}"),
            Text("${value}"),
          ],
      ),
    );
}

InputDecoration kInputDecoration(String label){
  return InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
  );
}

TextButton kTextButtonGoToDashboard(String label, Function onPressed, {double fSize=17, Color btnColor=Colors.blue, EdgeInsets btnPadding=const EdgeInsets.only(top: 10, bottom: 10, right: 10)}){
  return TextButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50)),
            )
          ),
          backgroundColor: WidgetStateColor.resolveWith((states)=> btnColor),
          padding: WidgetStateProperty.resolveWith((states) => btnPadding),
        ),
        child: Text(label, style: TextStyle(color: Colors.white,fontSize: fSize,fontWeight: FontWeight.bold),),
      );
}

IconButton kIconButton(final iconset, Function onPressed, {double fSize=30, Color fColor=Colors.white, Color btnColor=Colors.blue, EdgeInsets btnPadding=const EdgeInsets.all(15)}){
  return IconButton(
    onPressed: () => onPressed(), 
    icon: Icon(iconset,color: fColor),
    iconSize: fSize,
    style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )
          ),
          backgroundColor: WidgetStateColor.resolveWith((states)=> btnColor),
          padding: WidgetStateProperty.resolveWith((states) => btnPadding),
        ),
    );
}

TextButton kTextButton(String label, Function onPressed, {double fSize=17, Color btnColor=Colors.blue, EdgeInsets btnPadding=const EdgeInsets.symmetric(vertical: 10)}){
  return TextButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )
          ),
          backgroundColor: WidgetStateColor.resolveWith((states)=> btnColor),
          padding: WidgetStateProperty.resolveWith((states) => btnPadding),
        ),
        child: Text(label, style: TextStyle(color: Colors.white,fontSize: fSize,fontWeight: FontWeight.bold),),
      );
}

CurvedNavigationBar kNavigate(int page){
  return CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: page,
        onTap: (index) {
            navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>arrPage[index]), (route) => false);

            // navigatorKey.currentState?.pushNamed("${arrPage[index]}");
        },
        height: 70,
        color: Color.fromRGBO(111, 78, 55, 1),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            CupertinoIcons.cart_fill,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
      );
}

