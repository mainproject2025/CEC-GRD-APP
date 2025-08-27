import 'package:cecgrid/pages/logIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitSpinningLines(
      color: Colors.white,
       
    );

    return Scaffold(
      backgroundColor: Color(0xFF5B5CE6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             
            SizedBox(height: 30),
            Text(
              "CECGrid",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Perfect Seats. Every Time",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 30),
            spinkit, // your custom loader
          ],
        ),
      ),
    );
  }
}
