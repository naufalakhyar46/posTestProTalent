import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/user.dart';
import 'package:tpos_app/pages/dashboard/userDashboard.dart';
import 'package:tpos_app/services/user_service.dart';

class UserFormDashboardPage extends StatefulWidget{
  final User? user;
  final String? title;

  UserFormDashboardPage({
    this.user,
    this.title,
  });
  @override
  _UserFormDashboardPageState createState() => _UserFormDashboardPageState();
}

class _UserFormDashboardPageState extends State<UserFormDashboardPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
   TextEditingController
    nameController = TextEditingController(),
    emailController = TextEditingController(),
    usernameController = TextEditingController();
  int? roleController = null;    
  // List of items in our dropdown menu 
  var items = [     
    {'label':'Admin','value':1}, 
    {'label':'Cashier','value':2},
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
    ApiResponse response = await createUser(nameController.text, emailController.text, usernameController.text, roleController, _imageFile);

    if(response.error == null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserDashboardPage()));
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

  void _editPost(int userId) async {
    ApiResponse response = await updateUser(userId, nameController.text, emailController.text, usernameController.text, roleController, _imageFile);
    if(response.error == null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserDashboardPage()));
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
    if(widget.user != null){
      nameController.text = widget.user!.name ?? '';
      emailController.text = widget.user!.email.toString();
      usernameController.text = widget.user!.username ?? '';
      roleController = widget.user!.role ?? 2;
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
                Navigator.pushNamed(context, 'admin/user');
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
                              decoration: widget.user == null ? BoxDecoration(
                                image: _imageFile == null ? null : DecorationImage(
                                  image: FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover
                                )
                              ) :
                              BoxDecoration(
                                image: _imageFile == null ? (widget.user!.image == null ? null : DecorationImage(
                                  image: NetworkImage('${widget.user!.imagepath}'),
                                  fit: BoxFit.cover
                                )) : DecorationImage(
                                  image: _imageFile == null ? NetworkImage('${widget.user!.imagepath}') : FileImage(_imageFile ?? File('')),
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
                          decoration: kInputDecoration('Name'),
                          controller: nameController,
                          validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: usernameController,
                          validator: (val) => val!.isEmpty ? 'Invalid Username' : null,
                          decoration: kInputDecoration('Username'),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val!.isEmpty ? 'Invalid Email address' : null,
                          decoration: kInputDecoration('Email address')
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
                              value: roleController,
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
                                  roleController = newValue!; 
                                }); 
                              }, 
                            ),
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
              if(_formkey.currentState!.validate()){
                setState(() {
                  loading = !loading;
                  if(widget.user == null){
                    _createPost();
                  }else{
                    _editPost(widget.user!.id ?? 0);
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