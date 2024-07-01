import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tpos_app/pages/auth/login.dart';

class Loading extends StatefulWidget{
  @override
  _LoadingState createState() => _LoadingState(); 
}

class _LoadingState extends State<Loading> {

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Login()));
    });
  }

  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              SizedBox(height: 287.h),
              Container(
                child: Image.asset(
                  'assets/icon100x.png',
                  height: 120,
                  fit:BoxFit.fitHeight
                ),
              ),
              SizedBox(height: 15.h)
            ],
          ),
        ),
    );
  }

}