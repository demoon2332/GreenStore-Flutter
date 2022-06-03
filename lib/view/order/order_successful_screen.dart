import 'package:flutter/material.dart';

class OrderSucessfulScreen extends StatelessWidget {
  const OrderSucessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Đặt hàng thành công',
                style: const TextStyle(color: Colors.black)),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.done,
                    size: 108,
                    color: Colors.green,
                  ),
                  const Text('Đặt hàng thành công', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 12),
                  const Text('Đơn hàng của bạn đang được hệ thống xử lý.'),
                  const SizedBox(height: 12),
                  const Text('Chọn mục Lịch sử đơn hàng để xem chi tiết.'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/');
                      },
                        child: const Text('Quay về trang chủ')),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
