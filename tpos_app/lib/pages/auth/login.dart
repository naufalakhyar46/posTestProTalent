import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/user.dart';
import 'package:tpos_app/services/user_service.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loadUserInfo() async {
    String token = await getToken();
    if(token != ''){
      ApiResponse response = await getUserDetail();
      if(response.error == null){
        Navigator.pushNamed(context, "mainPage");
      }else{
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
          content: response.error != null ? Text('${response.error}') : Text('No Connection'),
        ));
      }
    }
  }

  void _loginUser() async {
    ApiResponse response = await login(txtUsername.text, txtPassword.text);
    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }else{
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        )
      );
    }
  }

  void _saveAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setInt('roleUser', user.role ?? 0);
    userRole = user.role ?? 0;
    Navigator.pushNamed(context, "mainPage");
  }

  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Form(
        key: formkey,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              SizedBox(height: 77.h),
              Container(
                child: Image.asset(
                  'assets/icon100x.png',
                  height: 120,
                  fit:BoxFit.fitHeight
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                width: 343.w,
                height: 43.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.r)
                ),
                child: TextFormField(
                  controller: txtUsername,
                  validator: (val) => val!.isEmpty ? 'Invalid username/email address' : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    hintText: 'Username / Email address',
                    border: InputBorder.none
                  ),
                ),
              ),
              SizedBox(height: 19.h),
              Container(
                width: 343.w,
                height: 43.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.r)
                ),
                child: TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    hintText: 'Password',
                    border: InputBorder.none
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              kTextButton('Login', (){
                if(formkey.currentState!.validate()){
                  setState(() {
                    loading = !loading;
                    _loginUser();
                  });
                }
              },
              fSize: 18,
              btnColor: Color.fromRGBO(111, 78, 55, 1)
              )
            ],
          ),
        ),
      ),
    );
  }
}