import 'package:flutter/material.dart';
import 'package:travel/pages/dashboard.dart';
import 'package:travel/style/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final sH = MediaQuery.of(context).size.height;
    final sW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: sW,
        height: sH,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/splash.jpg'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 700),
          child: Center(
            child: Text('Gallery', style: logo),
          ),
        ),
      ),
    );
  }
}
