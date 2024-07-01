import 'package:flutter/material.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/user.dart';
import 'package:tpos_app/services/user_service.dart';
import 'package:tpos_app/widgets/mainscreen/profilePage/itemProfile.dart';
// import 'package:tpos_app/utils/partials.dart';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool loading = true;

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
          automaticallyImplyLeading: false,
          scrolledUnderElevation:0,
          title: Text(
            'Profile',
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
      body: loading ? Center(child: CircularProgressIndicator()) 
            : RefreshIndicator(
        onRefresh: (){
              return _getUser();
            },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFEDECF2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )
          ),
          child: ListView(children: [
              userRole == 1 ? Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 150,
                  child: kTextButtonGoToDashboard(
                    'Go to dashboard',
                    (){
                      Navigator.pushNamed(context, 'admin/main-dashboard');
                    },
                    fSize: 15,
                    btnColor: Color.fromRGBO(111, 78, 55, 1),
                    )
                ),
              ) : SizedBox(),
              Container(
                padding: EdgeInsets.only(top:15,bottom: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )
                ),
                child: Column(
                  children:[
            
                    // // Items Widget
                    ItemsProfile(user:user),
                  ]
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