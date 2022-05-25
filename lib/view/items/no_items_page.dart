import 'package:flutter/material.dart';

class NoItemsPage {
  static Widget buildNoProductPage() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 200,child: Image.asset('assets/no_items_2.jpg', fit: BoxFit.fill)),
          const SizedBox(height:16),
          const Center(child: Text('Không có sản phẩm trong danh sách',))
        ]);
  }
}
