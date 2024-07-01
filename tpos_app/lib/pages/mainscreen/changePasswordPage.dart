import 'package:flutter/material.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/user.dart';
import 'package:tpos_app/pages/mainscreen/profilePage.dart';
import 'package:tpos_app/services/user_service.dart';

class ChangePasswordPage extends StatefulWidget{
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  User? user;
  bool loading = true;
  bool isPasswordCorrect = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController
  passwordController = TextEditingController(),
  passwordConfirmationController = TextEditingController();

  Future<void> _getUser() async {
    ApiResponse response = await getUserDetail();
    setState(() {
        loading = false;
    });
    if(response.error == null){
      setState(() {
        user = response.data as User;
      });
    }else if(response.error == unauthorized){
      Navigator.pushNamed(context, "login");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _checkPassword() async {
    ApiResponse response = await checkPassword(passwordController.text);
    setState(() {
      loading = false;
    });
    if(response.error == null){
      setState(() {
        isPasswordCorrect = true;
        passwordController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.data}'),
      ));
    }else if(response.error == unauthorized){
      Navigator.pushNamed(context, "login");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _changePassword() async {
    ApiResponse response = await changePassword(passwordController.text, passwordConfirmationController.text);
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
            'Change Password',
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
                            image: DecorationImage(
                              image: NetworkImage('${user!.imagepath}'),
                              fit: BoxFit.cover
                            ), 
                            color: Colors.amber
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    isPasswordCorrect 
                    ? 
                    Column(
                      children: [
                        TextFormField(
                          decoration: kInputDecoration('Password'),
                          controller: passwordController,
                          obscureText: true,
                          validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration: kInputDecoration('Password Confirmation'),
                          controller: passwordConfirmationController,
                          obscureText: true,
                          validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                        ),
                        SizedBox(height: 20,),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            kTextButton(
                                "Update Password",
                                (){
                                  if(formkey.currentState!.validate()){
                                    setState(() {
                                      loading = true;
                                    });
                                    _changePassword();
                                  }
                                },
                                btnColor:Color.fromRGBO(111, 78, 55, 1),
                                btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 30)
                              ),
                          ],
                        )
                    ])
                    : 
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        Center(
                          child: Text('Input password for change password'),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration: kInputDecoration('Password'),
                          controller: passwordController,
                          obscureText: true,
                          validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                        ),
                        SizedBox(height: 20,),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            kTextButton(
                                "Submit",
                                (){
                                  if(formkey.currentState!.validate()){
                                    setState(() {
                                      loading = true;
                                    });
                                    _checkPassword();
                                  }
                                },
                                btnColor:Color.fromRGBO(111, 78, 55, 1),
                                btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 30)
                              ),
                          ],
                        ),
                      ],
                    ),
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