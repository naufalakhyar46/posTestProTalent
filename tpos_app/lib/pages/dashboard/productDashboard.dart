import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/product.dart';
import 'package:tpos_app/pages/dashboard/productFormDashboard.dart';
import 'package:tpos_app/services/product_service.dart';
import 'package:tpos_app/services/user_service.dart';

class ProductDashboardPage extends StatefulWidget{
  @override
  _ProductDashboardPageState createState() => _ProductDashboardPageState();
}

class _ProductDashboardPageState extends State<ProductDashboardPage> {
  List<dynamic> _productList = [];
  int page = 1;
  bool loading = false;
  bool lastPage = false;
  AllProduct? allProduct;
  final scrollController = ScrollController();
  // get all post
  Future<void> retrieveProduct() async {
    ApiResponse response = await getProduct(page,'');
    if(response.error == null){
      allProduct = response.data as AllProduct;
      setState(() {
        final json = allProduct!.query as List<dynamic>;
        _productList = _productList + json;
        if(json.length == 0){
          lastPage = true;
        }
        loading = false;
      });
    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.pushNamed(context, 'login')
      });
    }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
        setState(() {
          loading = !loading;
        });
    }
  }

  void _hanldeDeleteProduct(int productId) async {
    ApiResponse response = await deleteProduct(productId);
    if(response.error == null){
      setState(() {
        lastPage = false;
        page = 1;
        _productList = [];
        retrieveProduct();
      });
    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.pushNamed(context, 'login')
      });
    }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      lastPage = false;
      page = 1;
      _productList = [];
      retrieveProduct();
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    retrieveProduct();
  }

  void _scrollListener(){
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        loading = true;
        if(!lastPage){
            page = page + 1;
        }
        retrieveProduct();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Color.fromRGBO(111, 78, 55, 1)),
            tooltip: 'Back',
            onPressed: () {
                Navigator.pushNamed(context, 'admin/main-dashboard');
            },
          ),
          scrolledUnderElevation:0,
          title: Text(
            'Product',
            style: TextStyle(
              color: Color.fromRGBO(111, 78, 55, 1),
              fontSize: 23,
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            Center(
              child: IconButton(
                  icon: Icon(
                          Icons.exit_to_app,
                          size: 32,
                          color: Color.fromRGBO(111, 78, 55, 1),
                        ), 
                  onPressed: () {
                    logout().then((value)=>{
                      Navigator.pushNamed(context, "login")
                    });
                  }
                )
          ),
          SizedBox(width: 10,),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFEDECF2)
        ),
        child: Column(
          children: [
            Expanded(
              child: loading ? Center(child: CircularProgressIndicator()) : RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: _productList.length,
                  itemBuilder: (BuildContext context, int index){
                    Product product = _productList[index];
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Image(
                                    height: 70,
                                    width: 70,
                                    image: NetworkImage(product.imagepath.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        width: 270,
                                        child: Text(
                                          product.product_name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16),
                                          ),
                                      ),
                                      Text(product.dolarprice.toString()),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(Icons.shop, size: 18,),
                                          Text(' Sold ${product.order_detail_count}')
                                        ],
                                      )
                                  ],
                                )
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 0.5,
                              color: Colors.black26,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                kTextButton(
                                  'Edit', 
                                  (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductFormDashboardPage(
                                      title: 'Edit Product',
                                      product:product,
                                    )));
                                  },
                                  fSize: 15,
                                  btnColor:Color.fromRGBO(111, 78, 55, 1),
                                  btnPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 52)
                                ),
                                SizedBox(width: 10,),
                                kTextButton(
                                  'Delete', 
                                  (){
                                    _hanldeDeleteProduct(product.id ?? 0);
                                  },
                                  fSize: 15,
                                  btnColor:Color.fromRGBO(111, 78, 55, 1),
                                  btnPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 52)
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 30, left: 10,right: 10),
        children: [
          kTextButton(
            'Add Product', 
            (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductFormDashboardPage(
                title: 'Add new product',
                product:null,
              )));
            },
            btnColor: Color.fromRGBO(111, 78, 55, 1)
          )
        ],
      ),
    );
  }
}