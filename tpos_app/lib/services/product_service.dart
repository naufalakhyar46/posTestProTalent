

import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:tpos_app/models/product.dart';
import 'package:tpos_app/services/user_service.dart';

Future<ApiResponse> getProduct(int? page, String? valueSearch) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL+'/product'+'?'+'page_size=10&val_search=${valueSearch}&current_page=${page}'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': 'Bearer $token',
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = AllProduct.fromJson(jsonDecode(response.body)['data']);
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

Future<ApiResponse> createProduct(String product_name, String description, dynamic price, String? category, File? _imageFile) async {
  var stream,lengthImage;
  if(_imageFile != null){
    stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    lengthImage = await _imageFile.length();
  }
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var uri = Uri.parse('${productURL}');
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
    request.fields['product_name'] = product_name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['category'] = category!;

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

Future<ApiResponse> updateProduct(int productId, String product_name, String description, dynamic price, String? category, File? _imageFile) async {
  var stream,lengthImage;
  if(_imageFile != null){
    stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    lengthImage = await _imageFile.length();
  }
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var uri = Uri.parse('${productURL}/${productId}');
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
    request.fields['product_name'] = product_name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['category'] = category!;

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

Future<ApiResponse> getDetailProduct(int productId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('${productURL}/${productId}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = Product.fromJson(jsonDecode(response.body)['data']);
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

Future<ApiResponse> deleteProduct(int productId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('${productURL}/${productId}'),
      headers: {
        'Accept': 'application/json',
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