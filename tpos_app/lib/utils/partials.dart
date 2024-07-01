
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tpos_app/constant.dart';
import 'dart:async';

import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/services/user_service.dart';

Future loadUserInfo() async {
    String token = await getToken();
    if(token == ''){
      navigatorKey.currentState?.pushNamed("login");
    }else{
      ApiResponse response = await getUserDetail();
      if(response.error == null){
        navigatorKey.currentState?.pushNamed("mainPage");
      }else if(response.error == unauthorized){
        navigatorKey.currentState?.pushNamed("login");
      }else{
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
          content: response.error != null ? Text('${response.error}') : Text('No Connection'),
        ));
      }
    }
}