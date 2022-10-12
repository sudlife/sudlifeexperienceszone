import 'dart:html';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'banner_screen.dart';

class AppWebView extends StatefulWidget {
  final String url;
  const AppWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  @override
  void initState() {
    // TODO: implement initState

    ui.platformViewRegistry.registerViewFactory(
        'hello-world-html',
        (int viewId) => IFrameElement()
          ..width = "${MediaQuery.of(context).size.width}"
          ..height = "${MediaQuery.of(context).size.height}"
          ..src = widget.url
          ..style.border = 'none');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              // builder: (context) => ChessGame()),
              //  builder: (context) => ZoneHomeScreen()),
              builder: (context) => const BannerScreen()),
        );
        exit(0);
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: HtmlElementView(
            viewType: 'hello-world-html',
          ),
        ),
      ),
    );
  }
}
