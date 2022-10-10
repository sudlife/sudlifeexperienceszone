import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RootedDevice extends StatelessWidget {
  const RootedDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/json/not_auth_mobile.json'),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "For your security, This app is restricted on rooted devices.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 120,
                child: ElevatedButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text("Ok"))),
          ],
        ),
      ),
    );
  }
}
