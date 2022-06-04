import 'package:flutter/material.dart';
import '../../convert/get_total_order.dart';
import 'package:provider/provider.dart';

import '../../convert/price_convert.dart';
import '../../models/export_models.dart';
import '../../repository/MemCartRepos.dart';
import '../../models/DAO/user_dao.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _code = 0;
  @override
  Widget build(BuildContext context) {
    var _userDAO = Provider.of<UserDao>(context, listen: false);

    return Consumer<MemCartRepos>(builder: (context, memCartRepos, child) {
      return SafeArea(
        child: Scaffold(
            body: Container(
          padding: const EdgeInsets.only(top: 36, left: 16, right: 16),
          child: initCartScreen(memCartRepos, _userDAO),
        )),
      );
    });
  }

  Widget cartBody(MemCartRepos memCartRepos, UserDao _userDAO) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Card",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(height: 12),
            Text(
              "Loading... Please wait.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 22),
          ],
        ),
        Expanded(
          child: showData(memCartRepos, _userDAO),
          flex: 4,
        ),
        showTotalBalance(memCartRepos),
      ],
    );
  }

  Widget cartBodyNull(MemCartRepos memCartRepos, UserDao _userDAO) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Cart",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(height: 28),
          ],
        ),
        const Expanded(
          child: Center(child: Text("There's nothing in your cart. ")),
          flex: 4,
        ),
      ],
    );
  }

  Widget initCartScreen(MemCartRepos memCartRepos, UserDao _userDAO) {
    return FutureBuilder<dynamic>(
        future: memCartRepos.fetchCart(_userDAO.userId() ?? ""),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == 0) {
                //SUCCESS
                _code = 0;
                return cartBody(memCartRepos, _userDAO);
              } else {
                _code = 1;
                return cartBodyNull(memCartRepos, _userDAO);
              }
            } else {
              _code = 1;
              return cartBodyNull(memCartRepos, _userDAO);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            if (_code == 0) {
              return cartBody(memCartRepos, _userDAO);
            }
            return cartBodyNull(memCartRepos, _userDAO);
          } else {
            return Center(
              child: Text('Something went wrong while loading.'),
            );
          }
        });
  }

  Widget showTotalBalance(MemCartRepos memCartRepos) {
    return SizedBox(
      height: 50,
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
              color: Colors.green,
            ),
            height: 35,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'c_order');
              },
              child: Center(
                  child: Text(
                'ORDER',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
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
              GetTotalOrder.getTotalOrder(memCartRepos.getCart()),
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
  Widget showData(MemCartRepos memCartRepos, UserDao _userDAO) {
    return FutureBuilder<dynamic>(
        future: memCartRepos.fetchCart(_userDAO.userId() ?? ""),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == 0) {
                return ListView.builder(
                    itemCount: memCartRepos.getLength(),
                    itemBuilder: (context, index) {
                      return buildItemSearch(memCartRepos.getCart()[index],
                          _userDAO, memCartRepos);
                    });
              } else {
                return Center(
                  child: Text("There's no product in order."),
                );
              }
            } else {
              return Center(
                child: Text("There's no product in order."),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: memCartRepos.getLength(),
                itemBuilder: (context, index) {
                  return buildItemSearch(
                      memCartRepos.getCart()[index], _userDAO, memCartRepos);
                });
          } else {
            return Center(
              child: Text('Something went wrong while loading.'),
            );
          }
        });
  }

  Widget buildItemSearch(
      ProductOrdered product, UserDao _userDAO, MemCartRepos memCartRepos) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        memCartRepos.deleteItem(_userDAO.userId()!, product.pid!);
      },
      background: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete, color: Colors.white, size: 32),
        ),
      ),
      child: SizedBox(
        //width: 200,
        height: 150,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'p_details', arguments: product.pid);
                    },
                    child: FittedBox(
                      child: Image.network(
                          'https://greenstore-api.herokuapp.com/' +
                              product.url!,
                          width: 150,
                          height: 125),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: Text(
                            product.title!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              PriceConvert.convertToVnd(product.price!),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 20),
                            )),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: updateCartBtn(product, _userDAO, memCartRepos),
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

  Widget updateCartBtn(
      ProductOrdered product, UserDao _userDAO, MemCartRepos memCartRepos) {
    return SizedBox(
      height: 50,
      child: Row(children: [
        //TODO: ADD ALL GESTURES DETECTOR
        Expanded(
          child: InkWell(
            onTap: () {
              memCartRepos.removeOneItemQuality(
                  _userDAO.userId()!, product.pid!);
            },
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
                color: Colors.green,
              ),
              height: 35,
              child: Center(
                  child: Text(
                '-',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                )),
            height: 35,
            child: Center(
                child: Text(
              product.quantity!.toString(),
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            )),
          ),
          flex: 4,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              memCartRepos.addOneItemQuality(_userDAO.userId()!, product.pid!);
            },
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
                color: Colors.green,
              ),
              height: 35,
              child: Center(
                  child: Text(
                '+',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          flex: 3,
        ),
      ]),
    );
  }
}
