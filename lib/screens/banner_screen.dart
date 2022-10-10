import 'dart:async';
import 'dart:io';

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
import 'package:sudlifeexperienceszone/screens/quiz_screen.dart';
import 'package:sudlifeexperienceszone/screens/webview_screen.dart';
import 'package:toast/toast.dart';

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
  late String url;
  late String name;
  late String imageUrl;

  GameBox({required this.url, required this.name, required this.imageUrl});
}

List<GameBox> gameList = [
  GameBox(
      url: "null", name: "Coin Saver", imageUrl: "assets/game/coin Saver.png"),
  GameBox(
      url: "https://d1jm9hpbqnjqwi.cloudfront.net",
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
  var _policyChecked = false.obs;
  var _femaleChecked = false.obs;
  var _maleChecked = true.obs;
  var _continuePressed = false.obs;
  var _otpDone = false.obs;
  var version = "1.2.0 (3)".obs;

  var _otpSent = false.obs;
  late CurvedAnimation curve;
  late AnimationController controller;
  late Animation<double> curtainOffset;
  TextEditingController root_controller = TextEditingController();

  String defaultFontFamily = GoogleFonts.poppins().fontFamily!;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController textController = TextEditingController();

  late AnimationController _controller;

  late bool autoFocus;
  var _timeout = false.obs;

  late String verification_id;
  late ConfirmationResult NewConfirmationResult;

  late Timer _timer;
  int _start = 60; // 2 minute

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
          print(_start);
        }
      },
    );
  }

  @override
  void initState() {
    getVersion();
    clear();
    if (FirebaseAuth.instance.currentUser != null) {
      startTimer();
    }

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
    widthSize = MediaQuery.of(context).size.width;
    heightSize = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: LightColor.buttonground,
        body: GestureDetector(
          onTap: () {
            if (FirebaseAuth.instance.currentUser != null) {
              _start = 60;
            }
          },
          onTapDown: (val) {
            if (FirebaseAuth.instance.currentUser != null) {
              _start = 60;
            }
          },
          onTapUp: (val) {
            if (FirebaseAuth.instance.currentUser != null) {
              _start = 60;
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
                            padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/site-logo.png"),
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        value: itemValue,
                        iconEnabledColor: LightColor.appBlue,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                                      color: LightColor.appBlue, fontSize: 16),
                                ),

                                //Divider(height: 1,thickness: 2,color: Colors.black),
                              ],
                            ),
                          );
                        }).toList(),
                        underline:
                            DropdownButtonHideUnderline(child: Container()),
                        onChanged: (newValue) {
                          if (FirebaseAuth.instance.currentUser != null) {
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
                  /*    SizedBox(
                        height: 300,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return gameBox(context, gameList[index].url,
                                gameList[index].name, gameList[index].imageUrl);
                          },
                          itemCount: gameList.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                        ),
                      ),*/

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        for (var element in gameList) ...{
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: gameBox(context, element.url, element.name,
                                element.imageUrl),
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
                      width: 160,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          side: const BorderSide(
                            width: 2,
                            color: Color(0xff0F5A93),
                          ),
                        ),
                        child: Text(
                          FirebaseAuth.instance.currentUser != null
                              ? "Logout"
                              : "Login",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () async {
                          // _showMyDialog();
                          FirebaseAuth.instance.currentUser != null
                              ? _showMyDialog()
                              : loginView(context);
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                    child: Text(
                      "Protecting Families, Enriching Lives",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
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
                if (_timer.isActive) {
                  _timer.cancel();
                }

                await FirebaseAuth.instance.signOut();
                showSnackBar("Logged out successfully!!");

                _nameController.clear();
                _phoneController.clear();
                _otpSent.value = false;
                _otpDone.value = false;

                setState(() {});
                Navigator.of(context).pop();
                //SystemNavigator.pop();
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
    return InkWell(
      onTap: () {
        if (FirebaseAuth.instance.currentUser == null) {
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
    );
  }

  void redirectToGame(String name, String url) async {
    if (_timer.isActive) {
      _timer.cancel();
    }

    if (url != "null") {
      Navigator.of(context).pop();
      await Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return GameWebViewScreen(
                key: _scaffoldKey, title: name, urlLink: url);
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
    _policyChecked = false.obs;
    _femaleChecked = false.obs;
    _maleChecked = true.obs;
    _continuePressed = false.obs;
    _continuePressed.value = false;
    _otpDone.value = false;
    _nameController.clear();
    _phoneController.clear();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          children: [
            Obx(() => !_otpSent.value
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
                                        checkColor: Colors.green,
                                        activeColor: Colors.white,
                                        value: _maleChecked.value,
                                        onChanged: (value) {
                                          setState(() {
                                            _maleChecked.value = value!;
                                            _femaleChecked.value = false;
                                          });
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
                                        checkColor: Colors.green,
                                        activeColor: Colors.white,
                                        value: _femaleChecked.value,
                                        onChanged: (value) {
                                          _femaleChecked.value = value!;
                                          _maleChecked.value = false;
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
                                        checkColor: Colors.blueAccent,
                                        activeColor: Colors.white,
                                        value: _policyChecked.value,
                                        onChanged: (value) {
                                          _policyChecked.value = value!;
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
                                        "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
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
                            } else if (!_policyChecked.value) {
                              showSnackBar("Please Accept the policy ");
                            } else if (int.tryParse(_phoneController.text) ==
                                null) {
                              showSnackBar("Only Number are allowed");
                            } else {
                              _continuePressed.value = true;
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
                              child: Obx(() => _continuePressed.value
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
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

                                        _otpSent.value = false;
                                        _timeout.value = false;
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
                        FadeAnimation(
                          0.5,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PinCodeTextField(
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
                                _otpDone.value = true;
                                _submitOTP(verification_id, value);
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
                                if (_timeout.value) {
                                  HapticFeedback.vibrate();

                                  _timeout.value = false;
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
                                      _timeout.value
                                          ? "Resend Otp"
                                          : "Didn't receive OTP! Resend in 2 minutes",
                                      style: TextStyle(
                                          fontFamily: defaultFontFamily,
                                          color: _timeout.value
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

                            _otpDone.value = true;
                            _submitOTP(verification_id, otpController.text);
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
                              child: Obx(() => _otpDone.value
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
    if (name == "Fun Facts") {
      Navigator.of(context).pop();
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const FunFacts_Screen();
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
            return const Quiz_Screen();
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
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(seconds: 120),
            verificationFailed: (FirebaseAuthException error) {
              if (kDebugMode) {
                print("Error => ${error.message}");
              }
              _continuePressed.value = false;
              showSnackBar("${error.message}");
            },
            codeSent: (String verificationId, int? resendToken) async {
              showSnackBar("OTP sent!");
              _start = 60;
              _otpSent.value = true;
              verification_id = verificationId;
              Navigator.pop(context);
              WidgetsBinding.instance
                  .addPostFrameCallback((timeStamp) => loginView(context));
              // Future.delayed(const Duration(milliseconds: 200), () => loginView(context));
            },
            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
              showSnackBar("Verified.");
              _start = 60;
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              _continuePressed.value = false;
              _timeout.value = true;

              showSnackBar("Timed out!");
            },
          );
          if (kDebugMode) {
            print('connected');
          }
        }
      } on SocketException catch (_) {
        _continuePressed.value = false;

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
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              timeout: const Duration(seconds: 120),
              verificationFailed: (FirebaseAuthException error) {
                print(error);
                _continuePressed.value = false;
                showSnackBar("${error.message}");
              },
              codeSent: (String verificationId, int? resendToken) async {
                showSnackBar("Resent OTP !");
                _timeout.value = false;
                _otpSent.value = true;
                _continuePressed.value = true;
                verification_id = verificationId;
                Navigator.pop(context);
                WidgetsBinding.instance
                    .addPostFrameCallback((timeStamp) => loginView(context));
                //Future.delayed(const Duration(milliseconds: 200), () => loginView(context));
              },
              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                showSnackBar("Verified.");
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                _timeout.value = true;

                //showSnackBar("Timeout!");
              },
            );

            print('connected');
          }
        } on SocketException catch (_) {
          _otpDone.value = false;
          _continuePressed.value = false;
          showSnackBar("Your internet connection is not working.");
        }
      }
    }
  }

  Future<void> _submitOTP(verificationId, String output) async {
    if (output.isEmpty) {
      showSnackBar("Please Enter Valid OTP !!");

      _otpDone.value = false;
      return;
    }

    if (output.length < 6) {
      showSnackBar("Please Enter Valid OTP !!");

      _otpDone.value = false;

      return;
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verification_id, smsCode: output);

    try {
      var response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (response.user != null) {
        _continuePressed.value = false;
        _otpDone.value = false;

        String? id = response.user?.uid;
        String? name = _nameController.text.toString();

        Map<String, String> userMap = {
          'Name': _nameController.text.toString(),
          'Number': _phoneController.text.toString(),
        };

        FirebaseDatabase.instance
            .ref()
            .child('SUDCustomer/Customers/' +
                name +
                "-" +
                id.toString() +
                "/" +
                DateTime.now().millisecondsSinceEpoch.toString())
            .set(userMap)
            .then((value) => null);
        _start = 60;
        startTimer();
        print("Verified");
        Navigator.of(context).pop();
        _nameController.clear();
        _phoneController.clear();
        showSnackBar("Logged in successfully !!");
        setState(() {});
      } else {
        _otpDone.value = false;
        _continuePressed.value = false;

        showSnackBar("Enter Correct OTP");
      }
    } on FirebaseAuthException catch (authError) {
      switch (authError.code) {
        case 'invalid-verification-code':
          showSnackBar("OTP Mismatch!");
          break;
        case 'session-expired':
          _otpSent.value = false;
          Navigator.pop(context);
          showSnackBar("Session Expired");
          break;
        default:
          showSnackBar("Something went wrong!");
          break;
      }
      _otpDone.value = false;
      _continuePressed.value = false;
    } catch (error) {
      _otpDone.value = false;
      _continuePressed.value = false;

      showSnackBar("Something Went Wrong!");
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _controller.dispose();
    controller.dispose();
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
    if (_timer.isActive) {
      _timer.cancel();
    }
    _start = 60;
    if (value == "Pay Premium") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                  key: _scaffoldKey,
                  title: 'Pay Premium',
                  url_link:
                      'https://www.sudlife.in/customer-service/premium-payment-options')));
      if (FirebaseAuth.instance.currentUser != null) {
        startTimer();
      }
    } else if (value == "Buy Online") {
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
    setState(() {
      // dropdownValue = newValue! as Item;
    });
  }

  void logOutUser(BuildContext context) async {
    clear();
    await FirebaseAuth.instance.signOut();
    showSnackBar("Session Timed out!!");
    _otpSent.value = false;
    _otpDone.value = false;
    setState(() {});
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = "${packageInfo.version} (${packageInfo.buildNumber})";
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: 40,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: (Colors.grey[800])!, // Set border color
            width: 0.2),
        // gradient: const LinearGradient(
        //   // begin: Alignment.centerLeft,
        //   // end: Alignment.centerRight,
        //   colors: <Color>[
        //     Color.fromRGBO(
        //         255, 241, 255, 1.0),
        //     Color.fromRGBO(
        //         243, 231, 255, 1.0),
        //   ],
        // ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 19,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        minLines: 1,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          color: Colors.black87,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: " ",
            filled: false,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
