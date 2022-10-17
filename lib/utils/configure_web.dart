import 'dart:html';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

import '../firebase_options.dart';

void configureApp() {
  setPathUrlStrategy();
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void configureHtml({required BuildContext context, required String url}) {
  ui.platformViewRegistry.registerViewFactory(
      'hello-world-html',
      (int viewId) => IFrameElement()
        ..width = "${MediaQuery.of(context).size.width}"
        ..height = "${MediaQuery.of(context).size.height}"
        ..src = url
        ..style.border = 'none');
}
