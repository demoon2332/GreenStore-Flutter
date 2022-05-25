import '../models/export_models.dart';

abstract class CartRepos{
  List<ProductOrdered> getCart();
  Future<int> fetchCart(String uid);
  Future<void> addOneItemQuality(String uid, String pid);
  Future<void> removeOneItemQuality(String uid, String pid);
  Future<void> deleteItem(String uid, String pid);
  Future<void> startOrder(String uid);
  int getLength();
  String getTotal();
  void close();
  Future<int> init(String uid);
}