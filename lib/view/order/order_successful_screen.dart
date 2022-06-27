import 'package:flutter/material.dart';

class OrderSucessfulScreen extends StatelessWidget {
  const OrderSucessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Order succeeded',
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
                  const Text('Order successfully', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 12),
                  const Text('Your order has been sent to store.'),
                  const SizedBox(height: 12),
                  const Text('Move ot order History to see detail.'),
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
                        child: const Text('Back to home')),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, 'his_order');
                        },
                        child: const Text('Back to History Screen')),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

