import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudlifeexperienceszone/screens/app_web_view.dart';
import 'package:sudlifeexperienceszone/screens/quiz_screen.dart';
import 'package:sudlifeexperienceszone/screens/webview_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../animation/fadeAnimation.dart';
import '../utils/light_color.dart';
import 'funfacts_screen.dart';
import 'game_view.dart';

class Item {
  final String name;
  final String icon;
  const Item(this.name, this.icon);
}

class GameBox {
  final String url;
  final String name;
  final String imageUrl;

  const GameBox(
      {required this.url, required this.name, required this.imageUrl});
}

List<GameBox> gameList = const [
  GameBox(
      url: "https://d1jm9hpbqnjqwi.cloudfront.net?game=coinsaver&",
      name: "Coin Saver",
      imageUrl: "assets/game/coin Saver.png"),
  GameBox(
      url: "https://d1jm9hpbqnjqwi.cloudfront.net?",
      name: "Aimvestment",
      imageUrl: "assets/game/Aimvestment.png"),
  GameBox(
      url: "null",
      name: "Protection Rush",
      imageUrl: "assets/game/Protection Rush.png"),
  GameBox(url: "null", name: "Fun Facts", imageUrl: "assets/game/Funfacts.png"),
  GameBox(
      url: "null", name: "Quiz Time", imageUrl: "assets/game/Quiz Time.png"),
];

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  @override
  BannerScreenState createState() {
    return BannerScreenState();
  }
}

const imageAsset = AssetImage("assets/images/new.png");

class BannerScreenState extends State<BannerScreen>
    with TickerProviderStateMixin {
  String url = "";
  double progress = 0;
  var policyChecked = false.obs;
  var femaleChecked = false.obs;
  var maleChecked = true.obs;
  var continuePressed = false.obs;
  var otpDone = false.obs;
  var version = "1.2.0 (3)".obs;

  var otpSent = false.obs;
  late CurvedAnimation curve;
  late Animation<double> curtainOffset;
  TextEditingController rootController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  String defaultFontFamily = GoogleFonts.poppins().fontFamily!;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController textController = TextEditingController();

  late bool autoFocus;
  var timeout = false.obs;

  late String verificationid;
  late ConfirmationResult newConfirmationResult;

  late Timer _timer;
  int _start = 61; // 2 minute

  var loginLogoutText =
      FirebaseAuth.instance.currentUser != null ? "Logout".obs : "Login".obs;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (FirebaseAuth.instance.currentUser != null) {
            logOutUser(context);
            _timer.cancel();
          }
        } else {
          _start--;
          debugPrint(_start.toString());
        }
      },
    );
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    startTimer();
    getVersion();
    clear();
    Future.delayed(const Duration(seconds: 1), () => setState(() {}));
    loginLogoutText.value = user != null ? "Logout" : "Login";
    super.initState();
  }

  late double widthSize;
  late double heightSize;

  List<Item> users = [
    const Item('Self-Help', 'assets/images/Group 3.png'),
    const Item('Buy Online', "assets/images/Group 3.png"),
    const Item('Pay Premium', "assets/images/Path 92.png"),
    const Item('Insurance Plan', "assets/images/Group 3.png"),
    const Item('Calculate Premium', "assets/images/Path 107.png"),
    const Item('Customer Portal', "assets/images/Group 6.png"),
    const Item('Claims', "assets/images/claims.png"),
  ];

  String dropdownValue = 'Self-Help';

  String? selectedValue;
  late Item itemValue = users[0];

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;

    if (FirebaseAuth.instance.currentUser != null) {
      _start = 61;
      if (!_timer.isActive) {
        startTimer();
      }
    } else {
      _timer.cancel();
    }
    widthSize = MediaQuery.of(context).size.width;
    heightSize = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    loginLogoutText.value = user != null ? "Logout" : "Login";
    setState(() {});
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: LightColor.buttonground,
        body: MouseRegion(
          onEnter: (val) {
            if (FirebaseAuth.instance.currentUser != null) {
              _start = 61;
            }
          },
          onExit: (val) {
            if (FirebaseAuth.instance.currentUser != null) {
              _start = 61;
            }
          },
          onHover: (val) {
            if (FirebaseAuth.instance.currentUser != null) {
              _start = 61;
            }
          },
          child: RawKeyboardListener(
            onKey: (val) {
              if (FirebaseAuth.instance.currentUser != null) {
                _start = 61;
              }
            },
            focusNode: FocusNode(),
            child: GestureDetector(
              onTap: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  _start = 61;
                }
              },
              onTapDown: (val) {
                if (FirebaseAuth.instance.currentUser != null) {
                  _start = 61;
                }
              },
              onTapUp: (val) {
                if (FirebaseAuth.instance.currentUser != null) {
                  _start = 61;
                }
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widthSize < 500
                          ? "assets/images/game_bg.png"
                          : "assets/images/game_bg_tab.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0),
                                          topLeft: Radius.circular(15.0),
                                          bottomLeft: Radius.circular(15.0)),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          80, 20, 80, 20),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/site-logo.png"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Text(
                                "SUD Life Experience Zone",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700, fontSize: 26),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 50,
                                width: 210,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                      topLeft: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0)),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  iconSize: 24,
                                  elevation: 16,
                                  isExpanded: true,
                                  value: itemValue,
                                  iconEnabledColor: LightColor.appBlue,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded),
                                  borderRadius: BorderRadius.circular(7.0),
                                  style: const TextStyle(
                                      color: LightColor.appBlue,
                                      fontWeight: FontWeight.w600),
                                  items: users.map((Item user) {
                                    return DropdownMenuItem(
                                      value: user,
                                      child: Row(
                                        children: [
                                          user.name != 'Self-Help'
                                              ? ImageIcon(
                                                  AssetImage(user.icon),
                                                  size: 25,
                                                  color: Colors.red,
                                                )
                                              : Container(),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            user.name,
                                            style: const TextStyle(
                                                color: LightColor.appBlue,
                                                fontSize: 16),
                                          ),

                                          //Divider(height: 1,thickness: 2,color: Colors.black),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  underline: DropdownButtonHideUnderline(
                                      child: Container()),
                                  onChanged: (newValue) {
                                    user = FirebaseAuth.instance.currentUser;
                                    setState(() {});
                                    if (user != null) {
                                      newValue = newValue as Item;
                                      redirectToWeb(value: newValue.name);
                                    } else {
                                      loginView(context);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                height: 10,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  for (var element in gameList) ...{
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: gameBox(context, element.url,
                                          element.name, element.imageUrl),
                                    ),
                                  }
                                ],
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                height: 10,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: SizedBox(
                                height: 60,
                                width: 161,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Color(0xff0F5A93),
                                    ),
                                  ),
                                  child: Text(
                                    loginLogoutText.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {});
                                    user = FirebaseAuth.instance.currentUser;
                                    user != null
                                        ? _showMyDialog()
                                        : loginView(context);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Protecting Families, Enriching Lives",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    user = FirebaseAuth.instance.currentUser;
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Do you want to Exit ?',
            style: TextStyle(color: Colors.blueAccent),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                showSnackBar("Logged out successfully!!");

                _nameController.clear();
                _phoneController.clear();
                otpSent.value = false;
                otpDone.value = false;
                loginLogoutText.value = "Login";

                setState(() {});

                if (_timer.isActive) {
                  _timer.cancel();
                }
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              child:
                  const Text('Yes', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('No', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  Widget gameBox(context, String url, String name, String imageUrl) {
    user = FirebaseAuth.instance.currentUser;
    setState(() {});
    return ZoomIn(
      duration: const Duration(milliseconds: 1000),
      child: InkWell(
        onTap: () {
          user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            loginView(context);
          } else {
            name != "Quiz Time" && name != "Fun Facts"
                ? redirectToGame(name, url)
                : redirectToScreen(name, url);
          }
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fill,
              width: 300,
              height: 300,
            )),
      ),
    );
  }

  void redirectToGame(String name, String url) async {
    if (_timer.isActive) {
      _timer.cancel();
    }
    if (url != "null") {
      if (kIsWeb) {
        Navigator.of(context).pop();
        await Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return AppWebView(
                key: _scaffoldKey,
                url: url,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }));

        // js.context.callMethod('open', [url, '_self']);
        return;
      }

      Navigator.of(context).pop();
      await Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return GameWebViewScreen(
              key: _scaffoldKey,
              title: name,
              urlLink: maleChecked.value
                  ? "${url}gender=male"
                  : "${url}gender=female",
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      showSnackBar("Coming Soon!");
    }
  }

  Object loginView(context) {
    TextEditingController otpController = TextEditingController();
    policyChecked = false.obs;
    femaleChecked = false.obs;
    maleChecked = true.obs;
    continuePressed = false.obs;
    continuePressed.value = false;
    otpDone.value = false;
    _nameController.clear();
    _phoneController.clear();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          children: [
            Obx(() => !otpSent.value
                ? Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(
                      //     color: Colors.white, // Set border color
                      //     width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.1,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Enter Your Details",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: defaultFontFamily,
                                        color: Colors.blueAccent,
                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.1,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: defaultFontFamily,
                                        color: Colors.blueAccent,
                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          0.5,
                          Container(
                            height: 53,
                            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color:
                                      (Colors.grey[800])!, // Set border color
                                  width: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 19,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextField(
                              minLines: 1,
                              maxLength: 30,
                              controller: _nameController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-z A-Z]")),
                              ],
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: defaultFontFamily,
                              ),
                              decoration: const InputDecoration(
                                  counter: SizedBox.shrink(),
                                  border: InputBorder.none,
                                  hintText: "Enter Your Full Name",
                                  filled: false,
                                  // fillColor: LightColor.yboxbackpurple,
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      // fontFamily:
                                      // defaultFontFamily,
                                      color: Colors.grey)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.1,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mobile Number",
                                    style: TextStyle(
                                        fontFamily: defaultFontFamily,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          0.5,
                          Container(
                            height: 53,
                            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color:
                                      (Colors.grey[800])!, // Set border color
                                  width: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 19,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              minLines: 1,
                              maxLength: 10,
                              controller: _phoneController,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: defaultFontFamily,
                              ),
                              decoration: const InputDecoration(
                                  counter: SizedBox.shrink(),
                                  border: InputBorder.none,
                                  // prefixIcon: Container(
                                  //   padding:
                                  //   EdgeInsets.all(11),
                                  //   height: 15,
                                  //   width: 15,
                                  //   child: Image.asset(
                                  //     'assets/icons/icons/email.png',
                                  //   ),
                                  // ),
                                  hintText: "  Enter 10 Digit Mobile Number",
                                  filled: false,
                                  // fillColor: LightColor.yboxbackpurple,
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      // fontFamily:
                                      // defaultFontFamily,
                                      color: Colors.grey)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.1,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender",
                                    style: TextStyle(
                                        fontFamily: defaultFontFamily,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 60, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.grey,
                                  ),
                                  child: Obx(() => Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.blueAccent,
                                        value: maleChecked.value,
                                        onChanged: (value) {
                                          maleChecked.value = value!;
                                          femaleChecked.value = !value;
                                        },
                                      )),
                                ),
                                const Text(
                                  "Male",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.grey,
                                  ),
                                  child: Obx(() => Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.blueAccent,
                                        value: femaleChecked.value,
                                        onChanged: (value) {
                                          femaleChecked.value = value!;
                                          maleChecked.value = !value;
                                        },
                                      )),
                                ),
                                const Text(
                                  "Female",
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.grey,
                                  ),
                                  child: Obx(() => Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.blueAccent,
                                        value: policyChecked.value,
                                        onChanged: (value) {
                                          policyChecked.value = value!;
                                        },
                                      )),
                                ),
                              ),
                              Flexible(
                                child: FadeAnimation(
                                    1.1,
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 40, 0),
                                      child: Text(
                                        "I hereby consent to receive policy related communication from SUD Life Insurance Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: defaultFontFamily,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.vibrate();
                            if (_nameController.text == "") {
                              showSnackBar("Please Enter Name");
                            } else if (_phoneController.text == "") {
                              showSnackBar("Please Enter Phone Number");
                            } else if (!policyChecked.value) {
                              showSnackBar("Please Accept the policy ");
                            } else if (int.tryParse(_phoneController.text) ==
                                null) {
                              showSnackBar("Only Number are allowed");
                            } else {
                              continuePressed.value = true;
                              _submitPhoneNumber();
                              // showSnackBar("Processing...");
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),

                            // height: height_size - 360,
                            // width: width_size - 470,
                            height: 50,
                            //width: 260,
                            decoration: BoxDecoration(
                              color: LightColor.appBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Obx(() => continuePressed.value
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    )
                                  : Text(
                                      'Enter the zone',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: defaultFontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                            ),
                          ),
                        ),
                        Obx(() => Text(
                              "Version: ${version.value}",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.black26),
                            ))
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.white, // Set border color
                          width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeAnimation(
                            1.1,
                            Row(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back_ios,
                                          color: Colors.grey),
                                      onPressed: () {
                                        HapticFeedback.vibrate();
                                        loginLogoutText.value =
                                            user != null ? "Logout" : "Login";
                                        otpSent.value = false;
                                        timeout.value = false;
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  "Mobile Verification",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: defaultFontFamily,
                                      color: Colors.blueAccent,
                                      //Color.fromRGBO(113, 56, 208, 1.0),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1.1,
                            Text(
                              "Enter 06 Digit OTP",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: defaultFontFamily,
                                  color: Colors.blueAccent,
                                  //Color.fromRGBO(113, 56, 208, 1.0),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: FadeAnimation(
                            0.5,
                            PinCodeTextField(
                              length: 6,
                              obscureText: false,
                              autoFocus: true,
                              textStyle: const TextStyle(color: Colors.black),
                              pinTheme: PinTheme(
                                selectedColor: Colors.blueAccent,
                                activeColor: Colors.blueAccent,
                                inactiveColor: Colors.grey.withOpacity(0.3),
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.grey.withOpacity(0.3),
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: false,
                              controller: otpController,
                              onCompleted: (value) {
                                otpDone.value = true;
                                _submitOTP(verificationid, value);
                              },
                              onChanged: (value) {},
                              beforeTextPaste: (text) {
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                              appContext: context,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1.1,
                            InkWell(
                              onTap: () {
                                if (timeout.value) {
                                  HapticFeedback.vibrate();

                                  timeout.value = false;
                                  //_timer.cancel();

                                  _resubmitPhoneNumber();

                                  //startTimer();

                                } else {
                                  showSnackBar("OTP already sent");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      timeout.value
                                          ? "Resend Otp"
                                          : "Didn't receive OTP! Resend in 2 minutes",
                                      style: TextStyle(
                                          fontFamily: defaultFontFamily,
                                          color: timeout.value
                                              ? Colors.blueAccent
                                              : Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.vibrate();

                            otpDone.value = true;
                            _submitOTP(verificationid, otpController.text);
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(50, 10, 50, 20),

                            // height: height_size - 360,
                            // width: width_size - 470,
                            height: 50,
                            //width: 260,
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0)),
                            ),
                            child: Center(
                              child: Obx(() => otpDone.value
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    )
                                  : Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: defaultFontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
          ],
        );
      },
    );
  }

  void redirectToScreen(String name, String url) {
    if (_timer.isActive) {
      _timer.cancel();
    }

    if (name == "Fun Facts") {
      Navigator.of(context).pop();
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const FunFactsScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const QuizScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
    }
  }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove('0answerA');
    prefs.remove('0answerB');
    prefs.remove('0answerC');
    prefs.remove('0answerD');

    prefs.remove('1answerA');
    prefs.remove('1answerB');
    prefs.remove('1answerC');
    prefs.remove('1answerD');

    prefs.remove('2answerA');
    prefs.remove('2answerB');
    prefs.remove('2answerC');
    prefs.remove('2answerD');

    prefs.remove('3answerA');
    prefs.remove('3answerB');
    prefs.remove('3answerC');
    prefs.remove('3answerD');

    prefs.remove('4answerA');
    prefs.remove('4answerB');
    prefs.remove('4answerC');
    prefs.remove('4answerD');

    prefs.remove('5answerA');
    prefs.remove('5answerB');
    prefs.remove('5answerC');
    prefs.remove('5answerD');

    prefs.remove('6answerA');
    prefs.remove('6answerB');
    prefs.remove('6answerC');
    prefs.remove('6answerD');

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

    prefs.remove('10answerA');
    prefs.remove('10answerB');
    prefs.remove('10answerC');
    prefs.remove('10answerD');

    prefs.remove('11answerA');
    prefs.remove('11answerB');
    prefs.remove('11answerC');
    prefs.remove('11answerD');

    prefs.clear();
  }

  Future<void> _submitPhoneNumber() async {
    String phoneNumber;

    if (_phoneController.text.length < 10 ||
        _phoneController.text.length > 10 ||
        _phoneController.text.isEmpty ||
        _phoneController.text == "") {
      showSnackBar("Enter Correct Phone Number");
    } else {
      phoneNumber = "+91 ${_phoneController.text.toString().trim()}";

      if (kDebugMode) {
        print(defaultTargetPlatform);
      }

      // if (TargetPlatform.android == defaultTargetPlatform ||
      //     TargetPlatform.iOS == defaultTargetPlatform ||
      //     TargetPlatform.macOS == defaultTargetPlatform) {

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 120),
          verificationFailed: (FirebaseAuthException error) {
            if (kDebugMode) {
              print("Error => ${error.message}");
              print(error);
            }

            continuePressed.value = false;
            showSnackBar("${error.message}");
          },
          codeSent: (String verificationId, int? resendToken) async {
            showSnackBar("OTP sent!");
            _start = 61;
            otpSent.value = true;
            verificationid = verificationId;
            Navigator.pop(context);
            WidgetsBinding.instance
                .addPostFrameCallback((timeStamp) => loginView(context));
            // Future.delayed(const Duration(milliseconds: 200), () => loginView(context));
          },
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            showSnackBar("Verified.");
            _start = 61;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            continuePressed.value = false;
            timeout.value = true;

            showSnackBar("Timed out!");
          },
        );
        if (kDebugMode) {
          print('connected');
        }
      } on SocketException catch (_) {
        continuePressed.value = false;

        showSnackBar("Your internet connection is not working! Try again");
      }
    }
  }

  Future<void> _resubmitPhoneNumber() async {
    String phoneNumber;

    if (_phoneController.text.length < 10 ||
        _phoneController.text.length > 10 ||
        _phoneController.text.isEmpty ||
        _phoneController.text == "") {
      showSnackBar("Enter Correct Phone Number");
    } else {
      phoneNumber = "+91 ${_phoneController.text.toString().trim()}";

      print(defaultTargetPlatform);
      if (TargetPlatform.android == defaultTargetPlatform ||
          TargetPlatform.iOS == defaultTargetPlatform ||
          TargetPlatform.macOS == defaultTargetPlatform) {
        try {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(seconds: 120),
            verificationFailed: (FirebaseAuthException error) {
              print(error);
              continuePressed.value = false;
              showSnackBar("${error.message}");
            },
            codeSent: (String verificationId, int? resendToken) async {
              showSnackBar("Resent OTP !");
              timeout.value = false;
              otpSent.value = true;
              continuePressed.value = true;
              verificationid = verificationId;
              Navigator.pop(context);
              WidgetsBinding.instance
                  .addPostFrameCallback((timeStamp) => loginView(context));
              //Future.delayed(const Duration(milliseconds: 200), () => loginView(context));
            },
            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
              showSnackBar("Verified.");
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              timeout.value = true;

              //showSnackBar("Timeout!");
            },
          );
        } on SocketException catch (_) {
          otpDone.value = false;
          continuePressed.value = false;
          showSnackBar("Your internet connection is not working.");
        }
      }
    }
  }

  Future<void> _submitOTP(verificationId, String output) async {
    if (output.isEmpty) {
      showSnackBar("Please Enter Valid OTP !!");

      otpDone.value = false;
      return;
    }

    if (output.length < 6) {
      showSnackBar("Please Enter Valid OTP !!");

      otpDone.value = false;

      return;
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationid, smsCode: output);

    try {
      var response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (response.user != null) {
        continuePressed.value = false;
        otpDone.value = false;

        String? id = response.user?.uid;
        String? name = _nameController.text.toString();

        Map<String, String> userMap = {
          'Name': _nameController.text.toString(),
          'Number': _phoneController.text.toString(),
        };

        FirebaseDatabase.instance
            .ref()
            .child(
                'SUDCustomer/Customers/$name-$id/${DateTime.now().millisecondsSinceEpoch.toString()}')
            .set(userMap)
            .then((value) => null);
        _start = 61;
        // startTimer();
        print("Verified");

        _nameController.clear();
        _phoneController.clear();
        showSnackBar("Logged in successfully !!");
        setState(() {});
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        otpDone.value = false;
        continuePressed.value = false;

        showSnackBar("Enter Correct OTP");
      }
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case 'invalid-verification-code':
          showSnackBar("OTP Mismatch!");
          break;
        case 'session-expired':
          otpSent.value = false;
          Navigator.pop(context);
          showSnackBar("Session Expired");
          break;
        default:
          showSnackBar("Something went wrong!");
          break;
      }
      otpDone.value = false;
      continuePressed.value = false;
    } catch (error) {
      otpDone.value = false;
      continuePressed.value = false;

      showSnackBar("Something Went Wrong!");
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  Future showProgressSnackBar(String error) async {
    HapticFeedback.vibrate();
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: LightColor.appBlue,
      content: SizedBox(
        height: 30,
        child: Row(
          children: const [
            Text(
              "Logging you in",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Spacer(),
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 60,
            ),
          ],
        ),
      ),
      // action: SnackBarAction(
      //   textColor: Colors.white,
      //   label: 'Okay',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  Future showSnackBar(String error) async {
    HapticFeedback.vibrate();
    ToastContext().init(context);
    Toast.show(error,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blueAccent,
        textStyle: const TextStyle(color: Colors.white));
    /* final snackBar = SnackBar(
      backgroundColor: LightColor.appBlue,
      content: Text(
        error,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Okay',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
    });*/
  }

  void redirectToWeb({required String value}) async {
    user = FirebaseAuth.instance.currentUser;
    setState(() {});
    if (value == "Pay Premium") {
      if (kIsWeb) {
        launchUrl(Uri.parse(
            'https://www.sudlife.in/customer-service/premium-payment-options'));
        /*  js.context.callMethod('open', [
          'https://www.sudlife.in/customer-service/premium-payment-options',
          '_self'
        ]);*/
        return;
      }

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Pay Premium',
                  url_link:
                      'https://www.sudlife.in/customer-service/premium-payment-options')));
      if (user != null) {
        startTimer();
      }
    } else if (value == "Buy Online") {
      if (kIsWeb) {
        launchUrl(Uri.parse(
            'https://bol.sudlife.in/ProductSelection/ProductSelectionPage'));
        /*   js.context.callMethod('open', [
          'https://bol.sudlife.in/ProductSelection/ProductSelectionPage',
          '_self'
        ]);*/
        return;
      }

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Buy Online',
                  url_link:
                      'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')));
      if (FirebaseAuth.instance.currentUser != null) {
        startTimer();
      }
    } else if (value == "Insurance Plan") {
      if (kIsWeb) {
        launchUrl(Uri.parse('https://www.sudlife.in/products/life-insurance'));

        /* js.context.callMethod('open',
            ['https://www.sudlife.in/products/life-insurance', '_self']);*/
        return;
      }

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Insurance Plans',
                  url_link: 'https://www.sudlife.in/products/life-insurance')));
      if (FirebaseAuth.instance.currentUser != null) {
        startTimer();
      }
    } else if (value == "Calculate Premium") {
      if (kIsWeb) {
        launchUrl(Uri.parse(
            'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'));
        return;
      }

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Calculate Premiums',
                  url_link:
                      'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')));
      if (FirebaseAuth.instance.currentUser != null) {
        startTimer();
      }
    } else if (value == "Claims") {
      if (kIsWeb) {
        launchUrl(Uri.parse('https://www.sudlife.in/claims'));

        /* js.context
            .callMethod('open', ['https://www.sudlife.in/claims', '_self']);*/
        return;
      }

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Claims',
                  url_link: 'https://www.sudlife.in/claims')));
      if (FirebaseAuth.instance.currentUser != null) {
        startTimer();
      }
    } else if (value == "Customer Portal") {
      if (kIsWeb) {
        launchUrl(Uri.parse('https://www.sudlife.in/contact-us'));
        /*js.context
            .callMethod('open', ['https://www.sudlife.in/contact-us', '_self']);*/
        return;
      }

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Customer Portal',
                  url_link: 'https://www.sudlife.in/contact-us')));
      if (FirebaseAuth.instance.currentUser != null) {
        startTimer();
      }
    } else {}

    if (_timer.isActive) {
      _timer.cancel();
    }
    _start = 61;
  }

  void logOutUser(BuildContext context) async {
    clear();
    await FirebaseAuth.instance.signOut();
    showSnackBar("Session Timed out!!");
    otpSent.value = false;
    otpDone.value = false;
    loginLogoutText.value = "Login";
    setState(() {});
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = "${packageInfo.version} (${packageInfo.buildNumber})";
  }
}
