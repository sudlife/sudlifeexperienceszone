import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'banner_screen.dart';

class GameWebViewScreen extends StatefulWidget {
  static const routeName = '/webview_screen';
  final String urlLink, title, gender;
  const GameWebViewScreen(
      {required Key key,
      required this.urlLink,
      required this.title,
      required this.gender})
      : super(key: key);

  @override
  State<GameWebViewScreen> createState() => _GameWebViewState();
}

class _GameWebViewState extends State<GameWebViewScreen> {
  int _stackToView = 1;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late Timer _timer;
  int _start = 60; // 1 minute

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (FirebaseAuth.instance.currentUser != null) {
            logOutUser(context);
            _timer.cancel();
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const BannerScreen()));
          }
        } else {
          _start--;
          print(_start);
        }
      },
    );
  }

  void logOutUser(BuildContext context) {
    clear();
    FirebaseAuth.instance.signOut();
    setState(() {});
  }

  @override
  void initState() {
    //startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                    child: WebView(
                  initialUrl: "${widget.urlLink}?gender=${widget.gender}",
                  gestureNavigationEnabled: false,
                  navigationDelegate: (request) {
                    if (request.url.contains(
                        'https://d1jm9hpbqnjqwi.cloudfront.net/exit')) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BannerScreen()),
                      ); // Close current window
                      return NavigationDecision.prevent; // Prevent opening url
                    } else if (request.url.contains(
                        'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')) {
                      _launchUrl(request.url);
                      return NavigationDecision.prevent; // Prevent opening url
                    } else {
                      return NavigationDecision.navigate; // Default decision
                    }
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: _handleLoad,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ))
              ],
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ));
  }

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not launch $url';
    }
    /*
    *   if (await canLaunchUrl(Uri.parse(link.url))) {
                        await launchUrl(Uri.parse(link.url),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $link';
                      }
                      * */
  }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove('0correctA');
    prefs.remove('0correctB');
    prefs.remove('0correctC');
    prefs.remove('0correctD');
    prefs.remove('0pressed');
    prefs.remove('0answerA');
    prefs.remove('0answerB');
    prefs.remove('0answerC');
    prefs.remove('0answerD');

    prefs.remove('1correctA');
    prefs.remove('1correctB');
    prefs.remove('1correctC');
    prefs.remove('1correctD');
    prefs.remove('1pressed');
    prefs.remove('1answerA');
    prefs.remove('1answerB');
    prefs.remove('1answerC');
    prefs.remove('1answerD');

    prefs.remove('2correctA');
    prefs.remove('2correctB');
    prefs.remove('2correctC');
    prefs.remove('2correctD');
    prefs.remove('2pressed');
    prefs.remove('2answerA');
    prefs.remove('2answerB');
    prefs.remove('2answerC');
    prefs.remove('2answerD');

    prefs.remove('3correctA');
    prefs.remove('3correctB');
    prefs.remove('3correctC');
    prefs.remove('3correctD');
    prefs.remove('3pressed');
    prefs.remove('3answerA');
    prefs.remove('3answerB');
    prefs.remove('3answerC');
    prefs.remove('3answerD');

    prefs.remove('4correctA');
    prefs.remove('4correctB');
    prefs.remove('4correctC');
    prefs.remove('4correctD');
    prefs.remove('4pressed');
    prefs.remove('4answerA');
    prefs.remove('4answerB');
    prefs.remove('4answerC');
    prefs.remove('4answerD');

    prefs.remove('5correctA');
    prefs.remove('5correctB');
    prefs.remove('5correctC');
    prefs.remove('5correctD');
    prefs.remove('5pressed');
    prefs.remove('5answerA');
    prefs.remove('5answerB');
    prefs.remove('5answerC');
    prefs.remove('5answerD');

    prefs.remove('6correctA');
    prefs.remove('6correctB');
    prefs.remove('6correctC');
    prefs.remove('6correctD');
    prefs.remove('6pressed');
    prefs.remove('6answerA');
    prefs.remove('6answerB');
    prefs.remove('6answerC');
    prefs.remove('6answerD');

    prefs.remove('7correctA');
    prefs.remove('7correctB');
    prefs.remove('7correctC');
    prefs.remove('7correctD');
    prefs.remove('7pressed');
    prefs.remove('7answerA');
    prefs.remove('7answerB');
    prefs.remove('7answerC');
    prefs.remove('7answerD');

    prefs.remove('8correctA');
    prefs.remove('8correctB');
    prefs.remove('8correctC');
    prefs.remove('8correctD');
    prefs.remove('8pressed');
    prefs.remove('8answerA');
    prefs.remove('8answerB');
    prefs.remove('8answerC');
    prefs.remove('8answerD');

    prefs.remove('9correctA');
    prefs.remove('9correctB');
    prefs.remove('9correctC');
    prefs.remove('9correctD');
    prefs.remove('9pressed');
    prefs.remove('9answerA');
    prefs.remove('9answerB');
    prefs.remove('9answerC');
    prefs.remove('9answerD');

    prefs.remove('10correctA');
    prefs.remove('10correctB');
    prefs.remove('10correctC');
    prefs.remove('10correctD');
    prefs.remove('10pressed');
    prefs.remove('10answerA');
    prefs.remove('10answerB');
    prefs.remove('10answerC');
    prefs.remove('10answerD');

    prefs.remove('11correctA');
    prefs.remove('11correctB');
    prefs.remove('11correctC');
    prefs.remove('11correctD');
    prefs.remove('11pressed');
    prefs.remove('11answerA');
    prefs.remove('11answerB');
    prefs.remove('11answerC');
    prefs.remove('11answerD');

    // prefs.remove('StateData');
    // prefs.remove('DistrictData');
    // prefs.remove('SchoolData');
    // prefs.remove('Top10Data');
    // prefs.remove('last');
    // prefs.remove('token');
    // prefs.remove('allData');
    // prefs.remove('complete');
    // prefs.remove('DataOnly');
    // prefs.remove('chatSound');
    // prefs.remove('email_token');
    prefs.clear();
  }

  void _handleLoad(String value) {
    if (mounted) {
      setState(() {
        _stackToView = 0;
      });
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const BannerScreen();
                },
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }));
          }),
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
