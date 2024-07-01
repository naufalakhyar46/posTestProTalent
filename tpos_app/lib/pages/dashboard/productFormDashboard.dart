import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/product.dart';
import 'package:tpos_app/pages/dashboard/productDashboard.dart';
import 'package:tpos_app/services/product_service.dart';
import 'package:tpos_app/services/user_service.dart';

class ProductFormDashboardPage extends StatefulWidget{
  final Product? product;
  final String? title;

  ProductFormDashboardPage({
    this.product,
    this.title,
  });
  @override
  _ProductFormDashboardState createState() => _ProductFormDashboardState();
}

class _ProductFormDashboardState extends State<ProductFormDashboardPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController
  productNameController = TextEditingController(),
  priceController = TextEditingController(),
  descriptionController = TextEditingController();
  String? categoryController = null;    
  // List of items in our dropdown menu 
  var items = [     
    {'label':'Food','value':'food'}, 
    {'label':'Drink','value':'drink'},
  ];
  bool loading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _imageValidate = false;

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _imageFile = File(image.path);
        _imageValidate = false;
      });
    }
  }

  void _createPost() async {
    // String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createProduct(productNameController.text, descriptionController.text, priceController.text, categoryController, _imageFile);

    if(response.error == null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDashboardPage()));
    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.pushNamed(context, "login")
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

  void _editPost(int productId) async {
    ApiResponse response = await updateProduct(productId, productNameController.text, descriptionController.text, priceController.text, categoryController, _imageFile);
    if(response.error == null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDashboardPage()));
    }else if(response.error == unauthorized){
      logout().then((value)=>{
        Navigator.pushNamed(context, "login")
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

  @override
  void initState() {
    super.initState();
    if(widget.product != null){
      productNameController.text = widget.product!.product_name ?? '';
      priceController.text = widget.product!.price.toString();
      descriptionController.text = widget.product!.description ?? '';
      categoryController = widget.product!.category ?? '';
    }
    setState(() {
      loading = false;
    });
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
                Navigator.pushNamed(context, 'admin/product');
            },
          ),
          scrolledUnderElevation:0,
          title: Text(
            widget.title.toString(),
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
      body: loading ? Center(child: CircularProgressIndicator()) : Container(
        decoration: BoxDecoration(
            color: Color(0xFFEDECF2)
        ),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key:_formkey,
                child: ListView(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: widget.product == null ? BoxDecoration(
                                image: _imageFile == null ? null : DecorationImage(
                                  image: FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover
                                )
                              ) :
                              BoxDecoration(
                                image: _imageFile == null ? (widget.product!.image == null ? null : DecorationImage(
                                  image: NetworkImage('${widget.product!.imagepath}'),
                                  fit: BoxFit.cover
                                )) : DecorationImage(
                                  image: _imageFile == null ? NetworkImage('${widget.product!.imagepath}') : FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover
                                )
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.image, size: 50, color: Colors.black38,),
                                  onPressed: (){
                                    getImage();
                                  },
                                ),
                              ),
                            ),
                          ),
                          _imageValidate ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Image required",
                              style: TextStyle(color: Colors.red),
                              ),
                          ) : SizedBox()
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: kInputDecoration('Product Name'),
                          controller: productNameController,
                          validator: (val) => val!.isEmpty ? 'Invalid Product Name' : null,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(5),border: Border.all(
                                width: 1,
                                color: Colors.black54
                              )),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              value: categoryController,
                              hint: const Text('Select Category'),
                              validator: (value) => value == null ? 'Category required' : null,
                              style:TextStyle(
                                color: Colors.black87,
                                fontSize: 16
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),     
                              items: items.map((Map<String, dynamic> items) { 
                                return DropdownMenuItem( 
                                  value: items['value'], 
                                  child: Text(items['label']), 
                                ); 
                              }).toList(), 
                              onChanged: (dynamic newValue) {  
                                setState(() { 
                                  categoryController = newValue!; 
                                }); 
                              }, 
                            ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? 'Invalid Price' : null,
                          decoration: kInputDecoration('Price'),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ]
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: kInputDecoration('Description'),
                        ),
                      ),
                    ),
                  ],
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
            'Submit', 
            (){
              if(widget.product == null){
                if(_imageFile == null){
                  loading = true;
                  _imageValidate = true;
                  setState(() {
                    loading = false;
                  });
                  return;
                }
              }else{
                if(widget.product?.image == '' && _imageFile == null){
                    loading = true;
                    _imageValidate = true;
                    setState(() {
                      loading = false;
                    });
                    return;
                }
              }
              if(_formkey.currentState!.validate()){
                setState(() {
                  loading = !loading;
                  if(widget.product == null){
                    _createPost();
                  }else{
                    _editPost(widget.product!.id ?? 0);
                  }
                });
              }
            },
            btnColor: Color.fromRGBO(111, 78, 55, 1)
          )
        ],
      ),
    );
  }
}