import 'package:flutter/material.dart';
import '../../convert/get_total_order.dart';
import '../../convert/price_convert.dart';

import 'package:provider/provider.dart';
import '../../models/DAO/user_dao.dart';
import '../../models/order.dart';

import '../../services/order_api.dart';
import '../items/no_items_page.dart';

class OrderHistoryListScreen extends StatefulWidget {
  const OrderHistoryListScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryListScreen> createState() => _OrderHistoryListScreenState();
}

class _OrderHistoryListScreenState extends State<OrderHistoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Purchase history',style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(
            color: Colors.green
          ),
        ),
          body: SafeArea(child: Container(
            padding:
            const EdgeInsets.only(top: 36, bottom: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Purchase History",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    SizedBox(height: 22),
                  ],
                ),
                Expanded(
                  child: showData(context),
                  flex: 4,
                ),
              ],
            ),
          )),
    );
    
  }

  Widget showData(BuildContext context) {
    var _userDAO = Provider.of<UserDao>(context, listen: false);
    return FutureBuilder<dynamic>(
      future: OrderApi().getAllOrders(_userDAO.userId()!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data !=null){
            var _data = snapshot.data;
            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final _order = Order.fromJson(_data[index]);
                return buildItemSearch(
                    context, _order);
              },
            );
          }
          else{
            return NoItemsPage.buildNoProductPage();
          }
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else{
          return const Center(child:Text('Something went wrong during loading'));
        }
      },
    );
  }

  Widget buildItemSearch(BuildContext context, Order _order) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, 'd_order',arguments: _order.oid);
      },
      child: SizedBox(
        //width: 200,
        height: 85,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: Text(
                            'Order #'+_order.oid!,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: Text(
                            GetTotalOrder.getTotalOrder(_order.items!),
                            style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
