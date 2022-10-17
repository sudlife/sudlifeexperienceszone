import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sudlifeexperienceszone/screens/splash_screen.dart';
import 'package:toast/toast.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://f73a38e5b22d44878752d36c8f5211cc@o4503981840728064.ingest.sentry.io/4503981842104320';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );

  // runApp(const MyApp());
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
        debugPrint("widget is resumed");
        // widget is resumed
        break;
      case AppLifecycleState.inactive:
        debugPrint("widget is inactive");
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        debugPrint("widget is paused");
        // widget is paused
        break;
      case AppLifecycleState.detached:
        debugPrint("widget is detached");
        // widget is detached
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
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
