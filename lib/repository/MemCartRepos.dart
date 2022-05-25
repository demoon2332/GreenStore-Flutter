import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product_ordered.dart';

import './CartRepos.dart';
import '../convert/get_total_order.dart';
import '../services/cart_api.dart';

class MemCartRepos extends CartRepos with ChangeNotifier{
  List<ProductOrdered> _cart = <ProductOrdered>[];

  @override
  Future<int> init(String uid) async{
    // TODO: implement init
    //TODO: Replace with getCart from Service
    var result = await CartApi().getCart(uid);
    if(result!= null){
      var _secondCart = <ProductOrdered>[];
      for(int i=0; i<result.length;i++){
        _secondCart.add(ProductOrdered.fromJson(result[i]));
        _cart = _secondCart;
      }
      return 0;
    }
    _cart.clear();
    return 1;
  }

  @override
  Future<int> fetchCart(String uid) async {
    // TODO: implement fetchCart
    var result = await CartApi().getCart(uid);
    if(result!= null){
      var _secondCart = <ProductOrdered>[];
      for(int i=0; i<result.length;i++){
        _secondCart.add(ProductOrdered.fromJson(result[i]));
        _cart = _secondCart;
      }
      return 0;
    }
    _cart.clear();
    return 1;
  }

  @override
  Future<void> addOneItemQuality(String uid, String pid) async{
    // TODO: implement addOneItemQuality
    await CartApi().increaseItemQuantityBy1(uid, pid);
    await fetchCart(uid);
    notifyListeners();
    return Future.value();
  }

  @override
  void close() {
    // TODO: implement close
    _cart.clear();
    notifyListeners();
  }

  @override
  Future<void> deleteItem(String uid, String pid) async {
    // TODO: implement deleteItem
    await CartApi().deleteItem(uid, pid);
    await fetchCart(uid);
    notifyListeners();
    return Future.value();
  }

  @override
  List<ProductOrdered> getCart() {
    // TODO: implement getCart
    return _cart;
  }

  @override
  Future<void> removeOneItemQuality(String uid, String pid) async{
    // TODO: implement removeOneItemQuality
    await CartApi().decreaseItemQuantityBy1(uid, pid);
    await fetchCart(uid);
    notifyListeners();
    return Future.value();
  }

  @override
  Future<void> startOrder(String uid) async{
    // TODO: implement startOrder
    await CartApi().startOrder(uid);
    await fetchCart(uid);
    notifyListeners();
    return Future.value();
  }

  @override
  int getLength() {
    // TODO: implement getLength
    return _cart.length;
  }

  @override
  String getTotal() {
    return GetTotalOrder.getTotalOrder(_cart);
  }



}