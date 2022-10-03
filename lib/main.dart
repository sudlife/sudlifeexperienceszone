import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:sudlifeexperienceszone/screens/splash_screen.dart';
import 'package:toast/toast.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

// adb -s emulator-5554 install /Users/ViS/life/sudlifeexperienceszone/build/app/outputs/flutter-apk/app-debug.apk
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) => null;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    // Add the observer.
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        print("widget is resumed");
        // widget is resumed
        break;
      case AppLifecycleState.inactive:
        print("widget is inactive");
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        print("widget is paused");
        // widget is paused
        break;
      case AppLifecycleState.detached:
        print("widget is detached");
        // widget is detached
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
      title: 'Experience Zone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        brightness: Brightness.dark,
      ),
      //home: ZoneHomeScreen(),
      home: const SplashScreen(),
    );
  }
}
