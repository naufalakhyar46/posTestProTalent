import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tpos_app/constant.dart';
import 'package:tpos_app/main.dart';
import 'package:tpos_app/models/api_response.dart';
import 'package:tpos_app/models/order.dart';
import 'package:tpos_app/pages/dashboard/detailOrderDashboard.dart';
import 'package:tpos_app/services/order_service.dart';
import 'package:tpos_app/services/user_service.dart';

class OrderDashboardPage extends StatefulWidget{
  @override
  _OrderDashboardPageState createState() => _OrderDashboardPageState();
}

class _OrderDashboardPageState extends State<OrderDashboardPage> with SingleTickerProviderStateMixin {
    late TabController tabController;
    int _selectedIndex = 0;
    String valueSearch = '';
    bool loading = false;
    List<dynamic> _listData = [];
    int page = 1;
    bool lastPage = false;
    AllOrder? allOrder;
    final scrollController = ScrollController();
  
    Future<void> retrieveData() async {
      switch(_selectedIndex){
          case 0:
            valueSearch = '';
          break;
          case 1:
            valueSearch = 'paid';
          break;
          case 2:
            valueSearch = 'unpaid';
          break;
          case 3:
            valueSearch = 'cancel';
          break;
          default:
          break;
      }
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
      tabController = new TabController(vsync: this, length: 4);
      tabController.animateTo(1);
      tabController.addListener((){
        setState(() {
          _selectedIndex = tabController.index;
          // retrieveData();
        });
      });
      super.initState();
      loading = true;
      scrollController.addListener(_scrollListener);
      retrieveData();
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
  void dispose(){
    tabController.dispose();
    super.dispose();
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
            "Order",
            style: TextStyle(
              color: Color.fromRGBO(111, 78, 55, 1),
              fontSize: 23,
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            controller: tabController,
            onTap: (index){
              setState(() {
                _selectedIndex = index;
                _handleRefresh();
              });
            },
            tabs: [
              Tab(text: "All Order"),
              Tab(text: "Paid Order"),
              Tab(text: "Unpaid Order"),
              Tab(text: "Cancelled Order"),
            ]
          ),
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
            Expanded(
              child: loading ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listData.length,
                        itemBuilder: (BuildContext context, int index){
                          Order order = _listData[index];
                          String productStatus = '';
                          if(order.product_status == 'paid'){
                            productStatus = 'Paid';
                          }else if(order.product_status == 'unpaid'){
                            productStatus = 'Unpaid';
                          }else{
                            productStatus = 'Cancelled';
                          }
                          return Card(
                            color: Colors.white,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailOrderDashboardPage(
                                  order:order,
                                )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(order.created_date.toString()),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(50)
                                          ),
                                          child: Text(productStatus.toString() ,style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      height: 0.5,
                                      color: Colors.black26,
                                    ),
                                    SizedBox(
                                        width: 270,
                                        child: Text(
                                          order.order_code.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16),
                                          ),
                                      ),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Icon(Icons.person, size: 18,),
                                        Text(' '+order.customer_name.toString()),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      height: 0.5,
                                      color: Colors.black26,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Text(' '+order.order_detail_count.toString(), style: TextStyle(color:Colors.black54)),
                                            Text(' Product', style: TextStyle(color:Colors.black54)),
                                          ],
                                        ),
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Text(' '+order.dolarprice.toString(), style: TextStyle(color:Colors.black54)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
