import 'package:flutter/material.dart';

import '../models/export_models.dart';
import './FavRepos.dart';

class MemFavRepos extends FavRepos with ChangeNotifier{
  final List<Product> _favList = <Product>[];

  @override
  void addProduct(Product product) {
    // TODO: implement addProduct
    _favList.add(product);
    notifyListeners();
  }

  @override
  void close() {
    // TODO: implement close
    _favList.clear();
    notifyListeners();
  }

  @override
  void deleteProduct(int position) {
    // TODO: implement deleteProduct
    if(position >= 0 && position < _favList.length){
      _favList.removeAt(position);
      notifyListeners();
    }
  }

  @override
  List<Product> getAll() {
    return _favList;
  }

  @override
  int getLength() {
    return _favList.length;
  }

  @override
  Product getProductByPosition(int position) {
    // TODO: implement getProductByPosition
    if(position >= 0 && position < _favList.length){
      return _favList[position];
    }
    return Product();
  }

}