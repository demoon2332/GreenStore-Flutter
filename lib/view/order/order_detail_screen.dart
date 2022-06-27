import 'package:flutter/material.dart';
import '../../convert/get_total_order.dart';

import '../../convert/price_convert.dart';
import '../../models/export_models.dart';
import '../../models/DAO/user_dao.dart';

import '../../services/order_api.dart';
import '../../repository/MemUserInfoRepos.dart';

import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final oid = ModalRoute.of(context)!.settings.arguments as String;
    var _userDAO = Provider.of<UserDao>(context, listen: false);

    return Scaffold(
          appBar: AppBar(
            title: Text(
              'Order #'+oid,
              style: const TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.green,
            ),
          ),
          body: SafeArea(child: Container(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: initCartScreen(oid, _userDAO),
          ))
          );
  }

  Widget cartBody(Order order, UserDao _userDAO) {
    var memUserInfoRepos = Provider.of<MemUserInfoRepos>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            primary: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _headerTitleUser(Icons.person, "Customer's information"),
                  const SizedBox(height: 12),
                  _cardUserInfo(memUserInfoRepos),
                  const SizedBox(height: 28),
                  _headerTitle(Icons.credit_card, "Payment Method"),
                  const SizedBox(height: 12),
                  _cardPaymentMethod(),
                  const SizedBox(height: 28),
                  _headerTitle(Icons.local_shipping, "Delivery method"),
                  const SizedBox(height: 12),
                  _cardShipping(),
                  const SizedBox(height: 28),
                  _headerTitle(Icons.shopping_cart, "Cart"),
                  const SizedBox(height: 12),
                  SizedBox(
                    child: showData(order, _userDAO),
                    height: 375,
                  ),
                ],
              ),
            ],
          ),
        ),
        showTotalBalance(order, _userDAO),
      ],
    );
  }

  Widget _cardUserInfo(MemUserInfoRepos memUserInfoRepos) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memUserInfoRepos.getName(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(memUserInfoRepos.getPhone()),
              const SizedBox(height: 10),
              Text(memUserInfoRepos.getAddress()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardPaymentMethod() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Paid at delivery",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardShipping() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Standard Delivery",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget _headerTitleUser(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget initCartScreen(String oid, UserDao _userDAO) {
    return FutureBuilder<dynamic>(
        future: OrderApi().getOrderDetail(_userDAO.userId()!, oid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData){
              var order = Order.fromJson(snapshot.data);
              return cartBody(order, _userDAO);
            } else {
              return const Center(
                child: Text('Data not found'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('Something went wrong during loading.'),
            );
          }
        });
  }

  Widget showTotalBalance(Order order, UserDao _userDAO) {
    return SizedBox(
      height: 50,
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4)),
              color: Colors.green,
            ),
            height: 35,
            child: const Center(
                child: Text(
              'TOTAL ORDER',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )),
          ),
          flex: 6,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                )),
            height: 35,
            child: Center(
                child: Text(
              GetTotalOrder.getTotalOrder(order.items!),
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            )),
          ),
          flex: 4,
        ),
      ]),
    );
  }

  //TODO: Add Dismissible to delete items
  Widget showData(Order order, UserDao _userDAO) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: order.items!.length,
      itemBuilder: (context, index) {
        return buildItemSearch(order.items![index],
            _userDAO);
      });
  }

  Widget buildItemSearch(
      ProductOrdered product, UserDao _userDAO) {
    return SizedBox(
      width: 200,
      //height: 125,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, 'p_details',arguments:  product.pid);
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Image.network(
                        'https://greenstore-api.herokuapp.com/' +
                            product.url!,
                        width: 150,
                        height: 100),
                    fit: BoxFit.fill,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: Text(
                            product.title!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              PriceConvert.convertToVnd(product.price!),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 20),
                            )),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Chip(
                              label: Text(
                                  'Quantity: ' + product.quantity!.toString())),
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
