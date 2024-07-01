import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/user.dart';
import 'package:tpos_app/pages/mainscreen/profilePage.dart';
import 'package:tpos_app/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePage extends StatefulWidget{
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  User? user;
  bool loading = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController
  nameController = TextEditingController(),
  emailController = TextEditingController(),
  usernameController = TextEditingController();

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _getUser() async {
    ApiResponse response = await getUserDetail();
    setState(() {
        loading = false;
    });
    if(response.error == null){
      setState(() {
        user = response.data as User;
        nameController.text = user!.name ?? '';
        emailController.text = user!.email ?? '';
        usernameController.text = user!.username ?? '';
      });
    }else if(response.error == unauthorized){
      Navigator.pushNamed(context, "login");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _updateProfile() async {
    ApiResponse response = await updateUser(user!.id ?? 0, nameController.text, emailController.text, usernameController.text, user!.role ?? 2, _imageFile);
    setState(() {
      loading = false;
    });
    if(response.error == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.data}'),
      ));
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage()));
    }else if(response.error == unauthorized){
      Navigator.pushNamed(context, "login");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _getUser();
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
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
                Navigator.pushNamed(context, 'profilePage');
            },
          ),
          scrolledUnderElevation:0,
          title: Text(
            'Update Profile',
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
          color: Color(0xFFEDECF2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )
        ),
        child: loading ? Center(child: CircularProgressIndicator()) 
    : RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: [
            Container(
              padding: EdgeInsets.only(top:15,bottom: 15),
              decoration: BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )
              ),
              child: Form(
                key: formkey,
                child: Column(
                  children:[
                    Center(
                      child: GestureDetector(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            image: _imageFile == null ? DecorationImage(
                              image: NetworkImage('${user!.imagepath}'),
                              fit: BoxFit.cover
                            ) : DecorationImage(
                              image: FileImage(_imageFile ?? File('')),
                              fit: BoxFit.cover
                            ),
                            color: Colors.amber
                          ),
                        ),
                        onTap: (){
                          getImage();
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: kInputDecoration('Name'),
                      controller: nameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: kInputDecoration('Username'),
                      controller: usernameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Username' : null,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: kInputDecoration('Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (val) => val!.isEmpty ? 'Invalid Email Address' : null,
                    ),
                    SizedBox(height: 20,),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        kTextButton(
                            "Update Profile",
                            (){
                              if(formkey.currentState!.validate()){
                                setState(() {
                                  loading = true;
                                });
                                _updateProfile();
                              }
                            },
                            btnColor:Color.fromRGBO(111, 78, 55, 1),
                            btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 30)
                          ),
                      ],
                    )
                  ]
                ),
              ),
            )
          ],
          ),
        ),
      ),
      bottomNavigationBar: kNavigate(2),
    );
  }
}