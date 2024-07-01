import 'package:flutter/material.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/user_service.dart';
import 'package:tpos_app/sizeconfig.dart';

class MainDashboardPage extends StatefulWidget{
  @override
  _MainDashboardPageState createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  bool loading = true;
  List _listData = [];

  Future<void> _getSummaryCard() async {
    ApiResponse response = await getSummary();
    if(response.error == null){
      setState(() {
        _listData = response.data as List;
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
      _getSummaryCard();
    });
  }

  @override
  void initState() {
    super.initState();
    _getSummaryCard();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Color.fromRGBO(111, 78, 55, 1)),
            tooltip: 'Back',
            onPressed: () {
                Navigator.pushNamed(context, 'mainPage');
            },
          ),
          scrolledUnderElevation:0,
          title: Text(
            'Dashboard',
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
        height: 650,
        decoration: BoxDecoration(
            color: Color(0xFFEDECF2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )
        ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 150,
                    child: kTextButtonGoToDashboard(
                      'Go to main screen',
                      (){
                        Navigator.pushNamed(context, 'mainPage');
                      },
                      fSize: 15,
                      btnColor: Color.fromRGBO(111, 78, 55, 1),
                      )
                  ),
                ),
                ListViewDashboard(cardConstant:_listData),
                Container(
                  margin:
                      EdgeInsets.only(left: SizeConfig.blockSizeVertical! * 3.4),
                  child: Text(
                    'Main Menus',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: const Color(0xFF111111),
                        fontFamily: 'Poppins',
                        fontSize: SizeConfig.blockSizeHorizontal! * 4.8,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical ?? 0 * 2.2),
                GridViewDashboard(),
              ],
            ),
        ),
      )
    );
  }
}

class GridViewDashboard extends StatefulWidget{
  _GridViewDashboardState createState() => _GridViewDashboardState();
}

class _GridViewDashboardState extends State<GridViewDashboard> {
  var menuConstant = <Map<String, String>>[
    {'menu': 'User', 'imagePath': 'user.png', 'path':'admin/user'},
    {'menu': 'Product', 'imagePath': 'product.png', 'path':'admin/product'},
    {'menu': 'List Order', 'imagePath': 'list-order.png', 'path':'admin/order'},
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 86.9,
        height: SizeConfig.blockSizeVertical! * 32.5,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: menuConstant.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "${menuConstant[index]['path']}");
                },
                child: Container(
                            width: SizeConfig.blockSizeHorizontal! * 24,
                            height: SizeConfig.blockSizeVertical! * 15,
                            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal! * 24,
                                  height: SizeConfig.blockSizeVertical! * 11.1,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(SizeConfig.blockSizeHorizontal! * 6.4))),
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/${menuConstant[index]["imagePath"]}',
                                        width: SizeConfig.blockSizeHorizontal! * 9.1,
                                        height: SizeConfig.blockSizeVertical! * 4.2,
                                      ),
                                    ),
                                  ]),
                                ),
                                Text(
                                  "${menuConstant[index]['menu']}",
                                  style: TextStyle(
                                      color: const Color(0xFF111111),
                                      fontFamily: 'Poppins',
                                      fontSize: SizeConfig.blockSizeHorizontal! * 3.7,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
              );
            }),
      ),
    );
  }
}

class ListViewDashboard extends StatefulWidget {


  ListViewDashboard({
    this.cardConstant,
  });
  
  final List? cardConstant;
  _ListViewDashboardState createState() => _ListViewDashboardState();
}

class _ListViewDashboardState extends State<ListViewDashboard> {
  var cardColor = <dynamic>[Color(0xFF1BA37A), Color(0xFF5F59E1), Color.fromARGB(255, 168, 74, 61)];
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical! * 32.5,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeVertical! * 3.4,
              vertical: SizeConfig.blockSizeVertical! * 3.7),
          scrollDirection: Axis.horizontal,
          itemCount: widget.cardConstant!.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: SizeConfig.blockSizeHorizontal! * 5.3,
            );
          },
          itemBuilder: (context, index) {
            return Container(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 6.4),
                      width: SizeConfig.blockSizeHorizontal! * 80,
                      height: SizeConfig.blockSizeVertical! * 23.4,
                      decoration: BoxDecoration(
                          color: cardColor[index],
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.blockSizeVertical! * 3.7))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 3.7,
                          ),
                          Text(widget.cardConstant![index]['label'].toString(),
                              style: TextStyle(
                                  color: const Color(0xFFFFFFFF),
                                  fontFamily: 'Poppins',
                                  fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                          Text(
                            "${widget.cardConstant![index]['value']}",
                            style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontFamily: 'Poppins',
                                fontSize: SizeConfig.blockSizeHorizontal! * 7.5,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical! * 2.9),
                          index == 2 ? 
                          Text(
                            'Total Order',
                            style: TextStyle(
                                  color: const Color(0xFFFFFFFF),
                                  fontFamily: 'Poppins',
                                  fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                                  fontWeight: FontWeight.w400),
                          ) :
                          Text(
                            'Total Sales',
                            style: TextStyle(
                                  color: const Color(0xFFFFFFFF),
                                  fontFamily: 'Poppins',
                                  fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                                  fontWeight: FontWeight.w400),
                          ),
                          Text('${widget.cardConstant![index]["value2"]}',
                              style: TextStyle(
                                  color: const Color(0xFFFFFFFF),
                                  fontFamily: 'Poppins',
                                  fontSize: SizeConfig.blockSizeHorizontal! * 6.4,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    );
          }),
    );
  }
}