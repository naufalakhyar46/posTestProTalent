
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:tpos_app/models/user.dart';

Future<ApiResponse> login(String username, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'username': username, 'password': password}
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body)['data']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> registerUser(String name, String email, String username, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept': 'application/json','Connection': 'keep-alive'},
      body: {
        'name': name, 
        'email': email, 
        'username': username, 
        'password': password,
        'password_confirmation': password
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body)['data']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> checkPassword(String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse("${baseURL}/check-password"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive'
        },
      body: {'password': password}
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> changePassword(String password, String password_confirmation) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse("${baseURL}/change-password"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive'
        },
      body: {'password': password,'password_confirmation':password_confirmation}
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getUser(int? page) async {
  ApiResponse apiResponse = ApiResponse();
  // try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/user'+'?'+'max_page=6&page_size=10&current_page=${page}'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = AllUser.fromJson(jsonDecode(response.body)['data']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  // }
  // catch(e){
  //     apiResponse.error = serverError;
  // }
  return apiResponse;
}

Future<ApiResponse> createUser(String name, String email, String username, dynamic role, File? _imageFile) async {
  var stream,lengthImage;
  if(_imageFile != null){
    stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    lengthImage = await _imageFile.length();
  }
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var uri = Uri.parse('$baseURL/user');
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token,
      'Connection': 'keep-alive'
    };
    var request = new http.MultipartRequest("POST", uri);

    if(_imageFile != null){
      var multipartFileSign = new http.MultipartFile('image', stream, lengthImage,
          filename: basename(_imageFile.path));

      request.files.add(multipartFileSign);
    }
    request.headers.addAll(headers);
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['role'] = role.toString();

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> updateUser(int userId, String name, String email, String username, dynamic role, File? _imageFile) async {
  var stream,lengthImage;
  if(_imageFile != null){
    stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    lengthImage = await _imageFile.length();
  }
  ApiResponse apiResponse = ApiResponse();
  // try {
    String token = await getToken();
    var uri = Uri.parse('$baseURL/user/$userId');
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token,
      'Connection': 'keep-alive'
    };
    var request = new http.MultipartRequest("POST", uri);

    if(_imageFile != null){
      var multipartFileSign = new http.MultipartFile('image', stream, lengthImage,
          filename: basename(_imageFile.path));

      request.files.add(multipartFileSign);
    }
    request.headers.addAll(headers);
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['role'] = role.toString();

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  // }
  // catch(e){
  //     apiResponse.error = serverError;
  // }
  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive'
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body)['data']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> deleteUser(int userId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('${baseURL}/user/${userId}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive'
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
      apiResponse.error = serverError;
  }
  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// get user id
Future<int> getUserRole() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('roleUser') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}