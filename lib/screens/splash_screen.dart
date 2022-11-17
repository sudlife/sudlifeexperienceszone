import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safe_device/safe_device.dart';
import 'package:sudlifeexperienceszone/screens/rooted_device.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

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

    if (await getRooted()) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RootedDevice()),
          (route) => false);
      return;
    }
    Timer(const Duration(milliseconds: 2000), () {
      HapticFeedback.vibrate();
      //Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BannerScreen()),
          (route) => false);
    });
  }

  Future<bool> getRooted() async {
    if (!GetPlatform.isWeb) {
      if (await SafeDevice.isJailBroken) {
        return true;
      }
    }
    return false;
  }
}
