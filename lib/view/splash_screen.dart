import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this)..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), (){
      Navigator.popAndPushNamed(context, 'login');
    });
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.green,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(scale: _animation,
                  child:  Image.asset('assets/splash_cart.jpg', width: 300, height: 300),
                ),
                const SizedBox(height:24),
                const Text("Loading...", style: TextStyle(color: Colors.white),),
              ],
            )
          ),
        ),
      ),
    );
  }
}
