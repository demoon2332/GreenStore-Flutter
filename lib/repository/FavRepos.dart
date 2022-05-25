import '../models/export_models.dart';

abstract class FavRepos{
  void addProduct(Product product);
  void deleteProduct(int position);
  void close();
  List<Product> getAll();
  int getLength();
  Product getProductByPosition(int position);
}