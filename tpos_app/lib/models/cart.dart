import 'package:tpos_app/models/product.dart';

class Cart {
  int? id;
  int? product_id;
  int? qty;
  Product? product;

  Cart({
    this.id,
    this.product_id,
    this.qty,
    this.product,
  });

  factory Cart.fromJson(Map<String, dynamic> json){
    return Cart(
      id: json['id'],
      product_id: json['product_id'],
      qty: json['qty'],
      product: Product(
        id: json['product']['id'],
        product_name: json['product']['product_name'],
        description: json['product']['description'],
        imagepath: json['product']['imagepath'],
        image: json['product']['image'],
        category: json['product']['category'],
        price: json['product']['price'],
        dolarprice: json['product']['dolarprice'],
        order_detail_count: json['product']['order_detail_count'],
      ),
    );
  }
}
