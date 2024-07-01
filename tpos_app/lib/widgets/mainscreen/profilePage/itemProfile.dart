import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/user.dart';

class ItemsProfile extends StatefulWidget {
  final User? user;

  ItemsProfile({
    this.user
  });

  _ItemsProfileState createState() => _ItemsProfileState();
}
class _ItemsProfileState extends State<ItemsProfile>{
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView(
       shrinkWrap: true,
       children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: CircleAvatar(
            child: ClipOval(
              child: Image.network(
                '${widget.user?.imagepath}',
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            radius: 50,
          ),
        ),
        kItemProfile("Nama","${widget.user?.name}"),
        kItemProfile("Username","${widget.user?.username}"),
        kItemProfile("Email Address","${widget.user?.email}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            kTextButton(
              "Update Profile",
              (){
                Navigator.pushNamed(context,"changeProfile");
              },
              btnColor:Color.fromRGBO(111, 78, 55, 1),
              btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 30)
            ),
            kTextButton(
              "Change Password",
              (){
                Navigator.pushNamed(context,"changePassword");
              },
              btnColor:Color.fromRGBO(111, 78, 55, 1),
              btnPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 30)
            )
          ],
        )
       ],
      ),
    );
  }
} 