import 'user.dart';

class Product {
  int? id;
  String? product_name;
  String? description;
  String? image;
  String? imagepath;
  String? category;
  int? price;
  String? dolarprice;
  int? order_detail_count;
  User? user;

  Product({
    this.id,
    this.product_name,
    this.description,
    this.image,
    this.imagepath,
    this.category,
    this.price,
    this.dolarprice,
    this.order_detail_count,
    this.user,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json){
    return Product(
      id: json['id'],
      product_name: json['product_name'],
      description: json['description'],
      imagepath: json['imagepath'],
      image: json['image'],
      category: json['category'],
      price: json['price'],
      dolarprice: json['dolarprice'],
      order_detail_count: json['order_detail_count'],
      user: User(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
        imagepath: json['user']['imagepath'],
        role: json['user']['role'],
      )
    );
  }
}

class AllProduct{
  int? totalItems;
  dynamic currentPage;
  String? pageSize;
  int? totalPages;
  int? startPage;
  dynamic endPage;
  int? startIndex;
  int? endIndex;
  List? query;

  AllProduct({
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

  factory AllProduct.fromJson(Map<String,dynamic> json){
    List<dynamic> arr = [];
    for(var item in json['query']){
      arr.add(
        Product(
          id: item['id'],
          product_name: item['product_name'],
          description: item['description'],
          imagepath: item['imagepath'],
          image: item['image'],
          category: item['category'],
          price: item['price'],
          dolarprice: item['dolarprice'],
          order_detail_count: item['order_detail_count'],
          user: User(
            id: item['user']['id'],
            name: item['user']['name'],
            image: item['user']['image'],
            imagepath: item['user']['imagepath'],
            role: item['user']['role'],
          )
        )
      );
    }
    return AllProduct(
      totalItems: json['totalItems'],
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
      startPage: json['startPage'],
      endPage: json['endPage'],
      startIndex: json['startIndex'],
      endIndex: json['endIndex'],
      query: arr
    );
  }
}