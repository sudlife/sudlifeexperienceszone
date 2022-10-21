import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudlifeexperienceszone/utils/configure_nonweb.dart'
    if (dart.library.html) 'package:sudlifeexperienceszone/utils/configure_web.dart';

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
    configureHtml(context: context, url: widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BannerScreen()),
        );
        exit(0);
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: kIsWeb
              ? HtmlElementView(
                  onPlatformViewCreated: (val) {
                    print("Alok val $val");
                  },
                  viewType: 'hello-world-html',
                )
              : Container(),
        ),
      ),
    );
  }
}
