import 'package:flutter/material.dart';
import '../convert/get_total_order.dart';

import '../convert/price_convert.dart';
import '../models/export_models.dart';

import '../repository/MemCartRepos.dart';
import '../repository/MemUserInfoRepos.dart';
import '../models/DAO/user_dao.dart';

import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  @override
  Widget build(BuildContext context) {
    var _userDAO = Provider.of<UserDao>(context, listen: false);

    return Consumer2<MemCartRepos, MemUserInfoRepos>(
        builder: (context, memCartRepos, memUserInfoRepos, child) {
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Xác nhận đơn hàng',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: const IconThemeData(
                color: Colors.green,
              ),
            ),
            body: Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: initCartScreen(memCartRepos, memUserInfoRepos, _userDAO),
            )),
      );
    });
  }

  Widget cartBody(MemCartRepos memCartRepos, MemUserInfoRepos memUserInfoRepos, UserDao _userDAO) {
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
                  _headerTitleUser(Icons.person, "Thông tin khách hàng"),
                  const SizedBox(height: 12),
                  _cardUserInfo(memUserInfoRepos),
                  const SizedBox(height: 28),
                  _headerTitle(Icons.credit_card, "Hình thức thanh toán"),
                  const SizedBox(height: 12),
                  _cardPaymentMethod(),
                  const SizedBox(height: 28),
                  _headerTitle(Icons.local_shipping, "Hình thức vận chuyển"),
                  const SizedBox(height: 12),
                  _cardShipping(),
                  const SizedBox(height: 28),
                  _headerTitle(Icons.shopping_cart, "Giỏ hàng"),
                  const SizedBox(height: 12),
                  SizedBox(
                    child: showData(memCartRepos, _userDAO),
                    height: 375,
                  ),
                ],
              ),
            ],
          ),
        ),
        showTotalBalance(memCartRepos, _userDAO),
      ],
    );
  }

  Widget _cardUserInfo(MemUserInfoRepos memUserInfoRepos) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(memUserInfoRepos.getName(), style: TextStyle(fontWeight: FontWeight.bold),),
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
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thanh toán khi nhận hàng", style: TextStyle(fontSize: 16),),
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
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Giao hàng tiêu chuẩn (sau 1 ngày làm việc)", style: TextStyle(fontSize: 14),),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios,color: Colors.green,),
              onPressed: (){
                //TODO: NAVIGATE TO PROFILE SCREEN
                Navigator.pushNamed(context, 'user_profile');
              },
            ),
          ),
        )
      ],
    );
  }

  Widget initCartScreen(MemCartRepos memCartRepos, MemUserInfoRepos memUserInfoRepos, UserDao _userDAO) {
    return FutureBuilder<dynamic>(
        future: memCartRepos.fetchCart(_userDAO.userId() ?? ""),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == 0) {
                //SUCCESS
                return cartBody(memCartRepos, memUserInfoRepos, _userDAO);
              } else {
                return const Center(
                  child: Text('Không có dữ liệu tìm thấy'),
                );
              }
            } else {
              return const Center(
                child: Text('Không có dữ liệu tìm thấy'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('Có lỗi khi tải dữ liệu.'),
            );
          }
        });
  }

  Widget showTotalBalance(MemCartRepos memCartRepos, UserDao _userDAO) {
    return SizedBox(
      height: 50,
      child: GestureDetector(
        onTap: () {
          //TODO: NAVIGATE TO CONFIRM ORDER SCREEN
          Navigator.pushNamed(context, 'search');
        },
        child: Row(children: [
          Expanded(
            child: InkWell(
              onTap: () {
                memCartRepos.startOrder(_userDAO.userId()!);
                Navigator.pushReplacementNamed(context, 's_order');
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
                  'ĐẶT HÀNG',
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
      ),
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
                    primary: false,
                    shrinkWrap: true,
                    itemCount: memCartRepos.getLength(),
                    itemBuilder: (context, index) {
                      return buildItemSearch(memCartRepos.getCart()[index],
                          _userDAO, memCartRepos);
                    });
              } else {
                return Center(
                  child: Text('Không có sản phẩm trong đơn hàng '),
                );
              }
            } else {
              return Center(
                child: Text('Không có sản phẩm trong đơn hàng '),
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
              child: Text('Có lỗi khi tải dữ liệu'),
            );
          }
        });
  }

  Widget buildItemSearch(
      ProductOrdered product, UserDao _userDAO, MemCartRepos memCartRepos) {
    return SizedBox(
      //width: 200,
      height: 125,
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
                      'https://cryptic-caverns-40086.herokuapp.com/' +
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
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Chip(
                            label: Text(
                                'Số lượng: ' + product.quantity!.toString())),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
