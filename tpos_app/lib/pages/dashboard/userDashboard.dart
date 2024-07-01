import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/user.dart';
import 'package:tpos_app/pages/dashboard/userFormDashboard.dart';
import 'package:tpos_app/services/user_service.dart';

class UserDashboardPage extends StatefulWidget{
  @override
  _UserDashboardPageState createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _userList = [];
  int page = 1;
  bool loading = false;
  bool lastPage = false;
  AllUser? allUser;
  final scrollController = ScrollController();
  // get all post
  Future<void> retrieveUser() async {
    ApiResponse response = await getUser(page);
    if(response.error == null){
      allUser = response.data as AllUser;
      setState(() {
        final json = allUser!.query as List<dynamic>;
        _userList = _userList + json;
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
       
    }
  }

  void _hanldeDeleteUser(int userId) async {
    ApiResponse response = await deleteUser(userId);
    if(response.error == null){
      setState(() {
        lastPage = false;
        page = 1;
        _userList = [];
        retrieveUser();
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
      _userList = [];
      retrieveUser();
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    retrieveUser();
  }

  void _scrollListener(){
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        loading = true;
        if(!lastPage){
            page = page + 1;
        }
        retrieveUser();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
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
            'User',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('*) Note : Default password after add user testapp123'),
            Expanded(
              child: loading ? Center(child: CircularProgressIndicator()) : RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: _userList.length,
                  itemBuilder: (BuildContext context, int index){
                    User user = _userList[index];
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
                                    image: NetworkImage(user.imagepath.toString()),
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
                                          user.name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16),
                                          ),
                                      ),
                                      Text(user.email.toString()),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(Icons.person, size: 18,),
                                          Text(user.role.toString() == '1' ? ' Admin' : ' Cashier')
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
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserFormDashboardPage(
                                      title: 'Edit User',
                                      user:user,
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
                                    _hanldeDeleteUser(user.id ?? 0);
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
            'Add User', 
            (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserFormDashboardPage(
                title: 'Add new user',
                user:null,
              )));
            },
            btnColor: Color.fromRGBO(111, 78, 55, 1)
          )
        ],
      ),
    );
  }
}