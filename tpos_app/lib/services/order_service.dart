
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/cart.dart';
import 'package:tpos_app/models/order.dart';
// import 'package:tpos_app/models/order.dart';
import 'package:tpos_app/services/user_service.dart';

Future<ApiResponse> getSummary() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/get-summary'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['data'];
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

Future<ApiResponse> getCart() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/cart'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    // print(jsonDecode(response.body)['data']);
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['data'].map((p) => Cart.fromJson(p)).toList();
        apiResponse.data as List;
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

Future<ApiResponse> checkout(dynamic order) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(baseURL+'/order'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8', 
        'Authorization': 'Bearer $token',
        },
        body: order
    );
    // print(jsonDecode(response.body));
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
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

Future<ApiResponse> addToCart(dynamic productId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(baseURL+'/cart'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
        body: {'product_id': productId.toString()}
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

Future<ApiResponse> destroyCart(dynamic cartId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse(baseURL+'/cart/${cartId}'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
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

Future<ApiResponse> getOrder(int? page, String? valueSearch) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/order'+'?'+'max_page=6&page_size=10&val_search=${valueSearch}&current_page=${page}'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    // print(jsonDecode(response.body)['data']);
    switch(response.statusCode){
      case 200:
        apiResponse.data = AllOrder.fromJson(jsonDecode(response.body)['data']);
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

Future<ApiResponse> getDetailOrder(int? orderId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/order/${orderId}'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    // print(jsonDecode(response.body)['data']);
    switch(response.statusCode){
      case 200:
        apiResponse.data = Order.fromJson(jsonDecode(response.body)['data']);
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

Future<ApiResponse> orderPaid(int? orderId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/order/${orderId}/paid'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    // print(jsonDecode(response.body)['data']);
    switch(response.statusCode){
      case 200:
        apiResponse.data = Order.fromJson(jsonDecode(response.body)['data']);
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

Future<ApiResponse> orderCancel(int? orderId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/order/${orderId}/cancel'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = Order.fromJson(jsonDecode(response.body)['data']);
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

