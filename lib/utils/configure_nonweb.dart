import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void configureApp() {}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

void configureHtml({required BuildContext context, required String url}) {}