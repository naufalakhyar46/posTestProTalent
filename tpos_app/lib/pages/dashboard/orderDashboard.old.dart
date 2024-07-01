import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/order.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/user_service.dart';

class OrderDashboardPageOld extends StatefulWidget{
  @override
  _OrderDashboardPageStateOld createState() => _OrderDashboardPageStateOld();
}

class _OrderDashboardPageStateOld extends State<OrderDashboardPageOld> with SingleTickerProviderStateMixin {
    // int _selectedIndex = 0;
    late TabController tabController;
    String valueSearch = '';
    bool loading = false;
    List<dynamic> _listData = [];
    int page = 1;
    bool lastPage = false;
    AllOrder? allOrder;
    final scrollController = ScrollController();
  
    void _handleTabSelection (){
      setState(() {
        loading = false;
        // _selectedIndex = tabController.index;
        print(tabController.index);
        switch(tabController.index){
          case 0:
            valueSearch = '';
            _handleRefresh();
            break;
          case 1:
            valueSearch = 'paid';
            _handleRefresh();
            break;
          case 2:
            valueSearch = 'unpaid';
            _handleRefresh();
            break;
          case 3:
            valueSearch = 'cancel';
            _handleRefresh();
            break;
          default:
            break;
        }
      });
    }

    Future<void> retrieveData() async {
      ApiResponse response = await getOrder(page, valueSearch);
      if(response.error == null){
        allOrder = response.data as AllOrder;
        setState(() {
          final json = allOrder!.query as List<dynamic>;
          _listData = _listData + json;
          if(json.length == 0){
            lastPage = true;
          }
          loading = false;
        });
      }else if(response.error == unauthorized){
        logout().then((value)=>{
          navigatorKey.currentState?.pushNamed('login')
        });
      }
    }

    Future<void> _handleRefresh() async {
      setState(() {
        lastPage = false;
        page = 1;
        _listData = [];
        retrieveData();
      });
    }

    @override
    void initState() {
      loading = true;
      tabController = TabController(vsync: this, length: 4);
      setState(() {
        tabController.animateTo(1);
      });
      super.initState();
      tabController.animation!.addListener(_handleTabSelection);
      // scrollController.addListener(_scrollListener);
      // retrieveData();
    }

    @override
    void dispose() {
      tabController.dispose();
      super.dispose();
    }

    void _scrollListener(){
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        loading = true;
        if(!lastPage){
            page = page + 1;
        }
        retrieveData();
    }
  }
    
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
              "Produk",
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
            bottom: TabBar(
              isScrollable: true,
              controller: tabController,
              tabs: [
                Tab(text: "All Order"),
                Tab(text: "Paid Order"),
                Tab(text: "Unpaid Order"),
                Tab(text: "Cancelled Order"),
              ]
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            for(var i=0;i < 4;i++)
              ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listData.length,
                  itemBuilder: (BuildContext context, int index){
                    Order order = _listData[index];
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
                                
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        width: 270,
                                        child: Text(
                                          order.order_code.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16),
                                          ),
                                      ),
                                      Text(order.customer_name.toString()),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(Icons.person, size: 18,),
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
                          ],
                        ),
                      ),
                    );
                  },
                )
          ],
        ),
      ),
    );
  }
}
