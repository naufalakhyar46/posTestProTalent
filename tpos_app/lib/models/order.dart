import 'package:tpos_app/models/product.dart';
import 'user.dart';

class DetailOrder {
  int? id;
  int? product_id;
  String? product_name;
  int? qty;
  int? price;
  String? product_status;
  int? per_total_price;
  Product? product;

  DetailOrder({
    this.id,
    this.product_id,
    this.product_name,
    this.qty,
    this.price,
    this.product_status,
    this.per_total_price,
    this.product
  });
  factory DetailOrder.fromJson(Map<dynamic, dynamic> json){
    return DetailOrder(
      id: json['id'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      qty: json['qty'],
      price: json['price'],
      product_status: json['product_status'],
      per_total_price: json['per_total_price'],
      product: Product(
        imagepath: json['product']['imagepath']
      ),
    );
  }
}

class Order {
  int? id;
  String? order_code;
  String? customer_name;
  String? product_status;
  int? total_price;
  int? order_detail_count;
  String? created_date;
  User? user;
  List<DetailOrder>? order_detail;
  String? dolarprice;

  Order({
    this.id,
    this.order_code,
    this.customer_name,
    this.product_status,
    this.total_price,
    this.order_detail_count,
    this.created_date,
    this.user,
    this.order_detail,
    this.dolarprice,
  });

  factory Order.fromJson(Map<dynamic, dynamic> json){
    return Order(
      id: json['id'],
      order_code: json['order_code'],
      customer_name: json['customer_name'],
      product_status: json['product_status'],
      total_price: json['total_price'],
      order_detail_count: json['order_detail_count'],
      created_date: json['created_date'],
      dolarprice: json['dolarprice'],
      user: User(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
        imagepath: json['user']['imagepath'],
        role: json['user']['role'],
      ),
      order_detail: [for(var item in json['order_detail'])DetailOrder.fromJson(item)]
    );
  }
}

class AllOrder{
  int? totalItems;
  dynamic currentPage;
  String? pageSize;
  int? totalPages;
  int? startPage;
  dynamic endPage;
  int? startIndex;
  int? endIndex;
  List<Order>? query;

  AllOrder({
    this.totalItems,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.startPage,
    this.endPage,
    this.startIndex,
    this.endIndex,
    this.query,
  });

  factory AllOrder.fromJson(Map<String,dynamic> json){
    return AllOrder(
      totalItems: json['totalItems'],
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
      startPage: json['startPage'],
      endPage: json['endPage'],
      startIndex: json['startIndex'],
      endIndex: json['endIndex'],
      query: [for(var item in json['query']) Order.fromJson(item)]
    );
  }
}