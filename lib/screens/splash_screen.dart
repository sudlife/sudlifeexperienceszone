import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'banner_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MediaQuery.of(context).size.width < 500
                      ? const AssetImage("assets/images/splash.png")
                      : const AssetImage("assets/images/slpash_tab.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    Timer(const Duration(milliseconds: 2000), () {
      HapticFeedback.vibrate();
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BannerScreen()));
    });
  }
}
