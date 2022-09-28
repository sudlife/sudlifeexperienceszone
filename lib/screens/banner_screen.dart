import 'dart:async';

import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animations/animations.dart';
//import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:sudlifeexperienceszone/screens/quiz_screen.dart';
import 'package:sudlifeexperienceszone/screens/webview_screen.dart';
import 'package:sudlifeexperienceszone/utils/root_check.dart';
import 'package:sudlifeexperienceszone/screens/zonehome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animation/fadeAnimation.dart';
import '../main.dart';
import '../utils/light_color.dart';
import 'dart:io';

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
  late String image_url;

  GameBox({required this.url, required this.name, required this.image_url});
}

List<GameBox> gameList = [
  GameBox(
      url: "https://d1jm9hpbqnjqwi.cloudfront.net",
      name: "Coin Saver",
      image_url: "assets/game/coin Saver.png"),
  GameBox(
      url: "https://ronin.co.in/sudlifegame/",
      name: "Aimvestment",
      image_url: "assets/game/Aimvestment.png"),
  GameBox(
      url: "https://ronin.co.in/sudlifegame/",
      name: "Protection Rush",
      image_url: "assets/game/Protection Rush.png"),
  GameBox(
      url: "https://ronin.co.in/sudlifegame/",
      name: "Fun Facts",
      image_url: "assets/game/Funfacts.png"),
  GameBox(
      url: "https://ronin.co.in/sudlifegame/",
      name: "Quiz Time",
      image_url: "assets/game/Quiz Time.png"),
];

class BannerScreen extends StatefulWidget {
  @override
  BannerScreenState createState() {
    return BannerScreenState();
  }
}
final imageAsset = AssetImage("assets/images/new.png");

class BannerScreenState extends State<BannerScreen>
    with TickerProviderStateMixin {
  //with SingleTickerProviderStateMixin {

  String url = "";
  double progress = 0;
  num _stackToView = 1;
  bool _policyChecked = false;
  late bool _femaleChecked;
  late bool _maleChecked;
  late bool _continuePressed;
  late bool _otpDone ;

  bool _otpSent = false;
  late CurvedAnimation curve;
  late AnimationController controller;
  late Animation<double> curtainOffset;
  TextEditingController root_controller = TextEditingController();



  String defaultFontFamily = 'Montserrat';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _firstDigitOtp = TextEditingController();
  final TextEditingController _secondDigitOtp = TextEditingController();
  final TextEditingController _thirdDigitOtp = TextEditingController();
  final TextEditingController _fourthDigitOtp = TextEditingController();
  final TextEditingController _fifthDigitOtp = TextEditingController();
  final TextEditingController _sixthDigitOtp = TextEditingController();

  final TextEditingController textController = TextEditingController();

  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late Animation<double> _animation;

  late bool autoFocus;
  late bool _timeout = false;

  late Timer _timer;
  int _start = 120; // 2 minute

  late String verification_id;
  late ConfirmationResult NewConfirmationResult;

  bool? _jailbroken;
  bool? _developerMode;
  bool _rootStatus = false;
  String root = '';

  // void startTimer() {
  //   setState(() {
  //     _timeout = false;
  //     _start = 120;
  //   });
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         clear();
  //         setState(() {
  //
  //           _timeout = true;
  //           //_otpSent = false;
  //           _timer.cancel();
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _timeout = false;
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    //checkDetection();
    checkRoot();
    clear();

    // _controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // )..repeat(reverse: false);
    // _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.fastOutSlowIn,
    // );
    //
    // controller = AnimationController(
    //     duration: const Duration(milliseconds: 500), vsync: this);

    super.initState();
  }

  late double widthSize;

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

  // Future<void> checkDetection() async {
  //   try {
  //
  //     bool? jailbroken = await FlutterRootDetection.jailbroken;
  //     bool? developerMode = await FlutterRootDetection.developerMode;
  //
  //
  //     if(mounted){
  //       setState(()  {
  //         _jailbroken = jailbroken;
  //         _developerMode = developerMode;
  //
  //         print("_jailbroken device is " + _jailbroken.toString());
  //         print("_developerMode device is " + _developerMode.toString());
  //       });
  //     }
  //   } on PlatformException {
  //     // _jailbroken = true;
  //     // _developerMode = true;
  //   }
  // }

  Future<void> checkRoot() async {
    // bool? result = await Root.isRooted();
    // if(mounted){
    //   setState(() {
    //     print("Root device is " + result.toString());
    //     _rootStatus = result!;
    //   });
    // }
    String? res;
    //res = await Root.exec(cmd: root_controller.text);
    //res = await Root.exec(cmd: "adb shell ps");
    //res = await Root.exec(cmd: "pm list packages | grep magisk");
    res = await Root.exec(cmd: "pm list packages");
    setState(() {
      if (res == 'true') {
        _rootStatus = true;
      } else if (res == 'false') {
        _rootStatus = false;
      }
      //_rootStatus = res!;
      //print("Root Command Device Detected "+root);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final double heightSize = MediaQuery.of(context).size.height;
    final double widthSize = MediaQuery.of(context).size.width;
    //print(heightSize.toString() + " * " + widthSize.toString());
    print("Banner Screen");
    String dropdownValue = 'One';

    // final Animation<double> offsetAnimation =
    // Tween(begin: 0.0, end: 24.0).chain(CurveTween(curve: Curves.elasticIn)).animate(controller)
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       controller.reverse();
    //     }
    //   });
    //
    // controller.forward(from: 0.0);

    //checkRoot();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: LightColor.buttonground,
        body: GestureDetector(
          onTap: () {

            FocusScope.of(context).unfocus();
            controller.isCompleted
                ? controller.reverse()
                : controller.forward();

          },

          // child: !_developerMode! ? widthSize < 900
          child: !_rootStatus
              ? widthSize < 900
                  ? SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          image: widthSize < 500
                              ? const DecorationImage(
                                  image:
                                      //AssetImage("assets/images/mobile_new.png"),
                                  AssetImage("assets/images/game_bg.png"),
                                      // AssetImage(
                                      //     "assets/images/EX Mob Bag.png"),
                                  fit: BoxFit.fill,
                                )
                              : const DecorationImage(
                                  image:
                                  // AssetImage(
                                  //     "assets/images/Text Background.png"),
                            AssetImage("assets/images/game_bg.png"),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        child: widthSize < 500
                            // ? Column(
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Container(
                            //               // height: 70,
                            //               // width: 160,
                            //               padding: const EdgeInsets.all(14),
                            //               decoration: const BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius: BorderRadius.only(
                            //                     topRight: Radius.circular(15.0),
                            //                     bottomRight:
                            //                         Radius.circular(15.0),
                            //                     topLeft: Radius.circular(15.0),
                            //                     bottomLeft:
                            //                         Radius.circular(15.0)),
                            //               ),
                            //               child: Container(
                            //                 // height: 50,
                            //                 // width: 100,
                            //                 padding: const EdgeInsets.fromLTRB(
                            //                     60, 15, 60, 15),
                            //                 decoration: const BoxDecoration(
                            //                   color: Colors.white,
                            //                   image: DecorationImage(
                            //                     image: AssetImage(
                            //                         "assets/images/site-logo.png"),
                            //                     fit: BoxFit.contain,
                            //                   ),
                            //                 ),
                            //                 child: null,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       const Spacer(),
                            //       // Container(
                            //       //   height: 50,
                            //       //   child: Center(
                            //       //     child: DropdownButtonHideUnderline(
                            //       //       child: DropdownButton2(
                            //       //         isExpanded: true,
                            //       //         hint: Row(
                            //       //           children: const [
                            //       //             Icon(
                            //       //               Icons.list,
                            //       //               size: 16,
                            //       //               color: Colors.yellow,
                            //       //             ),
                            //       //             SizedBox(
                            //       //               width: 4,
                            //       //             ),
                            //       //             Expanded(
                            //       //               child: Text(
                            //       //                 'Self-Help',
                            //       //                 style: TextStyle(
                            //       //                   fontSize: 14,
                            //       //                   fontWeight: FontWeight.bold,
                            //       //                   color: Colors.yellow,
                            //       //                 ),
                            //       //                 overflow:
                            //       //                     TextOverflow.ellipsis,
                            //       //               ),
                            //       //             ),
                            //       //           ],
                            //       //         ),
                            //       //         items: items
                            //       //             .map((item) =>
                            //       //                 DropdownMenuItem<String>(
                            //       //                   value: item,
                            //       //                   child: Text(
                            //       //                     item,
                            //       //                     style: const TextStyle(
                            //       //                       fontSize: 14,
                            //       //                       fontWeight:
                            //       //                           FontWeight.bold,
                            //       //                       color: Colors.white,
                            //       //                     ),
                            //       //                     overflow:
                            //       //                         TextOverflow.ellipsis,
                            //       //                   ),
                            //       //                 ))
                            //       //             .toList(),
                            //       //         value: selectedValue,
                            //       //         onChanged: (value) {
                            //       //           setState(() {
                            //       //             selectedValue = value as String;
                            //       //           });
                            //       //         },
                            //       //         icon: const Icon(
                            //       //           Icons.arrow_forward_ios_outlined,
                            //       //         ),
                            //       //         iconSize: 14,
                            //       //         iconEnabledColor: Colors.yellow,
                            //       //         iconDisabledColor: Colors.grey,
                            //       //         buttonHeight: 50,
                            //       //         buttonWidth: 160,
                            //       //         buttonPadding: const EdgeInsets.only(
                            //       //             left: 14, right: 14),
                            //       //         buttonDecoration: BoxDecoration(
                            //       //           borderRadius:
                            //       //               BorderRadius.circular(14),
                            //       //           border: Border.all(
                            //       //             color: Colors.black26,
                            //       //           ),
                            //       //           color: Colors.redAccent,
                            //       //         ),
                            //       //         buttonElevation: 2,
                            //       //         itemHeight: 40,
                            //       //         itemPadding: const EdgeInsets.only(
                            //       //             left: 14, right: 14),
                            //       //         dropdownMaxHeight: 200,
                            //       //         dropdownWidth: 200,
                            //       //         dropdownPadding: null,
                            //       //         dropdownDecoration: BoxDecoration(
                            //       //           borderRadius:
                            //       //               BorderRadius.circular(14),
                            //       //           color: Colors.redAccent,
                            //       //         ),
                            //       //         dropdownElevation: 8,
                            //       //         scrollbarRadius:
                            //       //             const Radius.circular(40),
                            //       //         scrollbarThickness: 6,
                            //       //         scrollbarAlwaysShow: true,
                            //       //         offset: const Offset(-20, 0),
                            //       //       ),
                            //       //     ),
                            //       //   ),
                            //       // ),
                            //
                            //
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.center,
                            //         mainAxisSize: MainAxisSize.max,
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         children: [
                            //           !_otpSent
                            //               ? Container(
                            //                   decoration: BoxDecoration(
                            //                     color: Colors.white,
                            //                     border: Border.all(
                            //                         color: Colors
                            //                             .white, // Set border color
                            //                         width: 0.2),
                            //                     borderRadius:
                            //                         BorderRadius.circular(15),
                            //                   ),
                            //                   margin: EdgeInsets.fromLTRB(
                            //                       40, 10, 40, 10),
                            //                   child: Column(
                            //                     children: [
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               children: [
                            //                                 Text(
                            //                                   "Enter Your Details",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 18),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment
                            //                                       .start,
                            //                               children: [
                            //                                 Text(
                            //                                   "Name",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 15),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       FadeAnimation(
                            //                         0.5,
                            //                         Container(
                            //                           height: 53,
                            //                           margin: const EdgeInsets
                            //                                   .fromLTRB(
                            //                               40, 0, 40, 0),
                            //                           decoration: BoxDecoration(
                            //                             color: Colors.white,
                            //                             border: Border.all(
                            //                                 color: (Colors.grey[
                            //                                     800])!, // Set border color
                            //                                 width: 0.2),
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(10),
                            //                             boxShadow: [
                            //                               BoxShadow(
                            //                                 color: Colors.grey
                            //                                     .withOpacity(
                            //                                         0.3),
                            //                                 spreadRadius: 1,
                            //                                 blurRadius: 19,
                            //                                 offset: const Offset(
                            //                                     0,
                            //                                     3), // changes position of shadow
                            //                               ),
                            //                             ],
                            //                           ),
                            //                           child: TextField(
                            //                             minLines: 1,
                            //                             maxLength: 30,
                            //                             controller:
                            //                                 _nameController,
                            //                             inputFormatters: <
                            //                                 TextInputFormatter>[
                            //                               FilteringTextInputFormatter
                            //                                   .allow(RegExp(
                            //                                       "[a-z A-Z]")),
                            //                             ],
                            //                             textAlignVertical:
                            //                                 TextAlignVertical
                            //                                     .center,
                            //                             textAlign:
                            //                                 TextAlign.center,
                            //                             style: TextStyle(
                            //                               color: Colors.black87,
                            //                               fontFamily:
                            //                                   defaultFontFamily,
                            //                             ),
                            //                             decoration:
                            //                                 const InputDecoration(
                            //                                     counter: SizedBox
                            //                                         .shrink(),
                            //                                     border:
                            //                                         InputBorder
                            //                                             .none,
                            //                                     hintText:
                            //                                         "  Enter Your Full Name",
                            //                                     filled: false,
                            //                                     // fillColor: LightColor.yboxbackpurple,
                            //                                     hintStyle: TextStyle(
                            //                                         fontSize: 14,
                            //                                         // fontFamily:
                            //                                         // defaultFontFamily,
                            //                                         color: Colors.grey)),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 const EdgeInsets
                            //                                         .fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment
                            //                                       .start,
                            //                               children: [
                            //                                 Text(
                            //                                   "Mobile Number",
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 15),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       FadeAnimation(
                            //                         0.5,
                            //                         Container(
                            //                           height: 53,
                            //                           margin: const EdgeInsets
                            //                                   .fromLTRB(
                            //                               40, 0, 40, 0),
                            //                           decoration: BoxDecoration(
                            //                             color: Colors.white,
                            //                             border: Border.all(
                            //                                 color: (Colors.grey[
                            //                                     800])!, // Set border color
                            //                                 width: 0.2),
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(10),
                            //                             boxShadow: [
                            //                               BoxShadow(
                            //                                 color: Colors.grey
                            //                                     .withOpacity(
                            //                                         0.3),
                            //                                 spreadRadius: 1,
                            //                                 blurRadius: 19,
                            //                                 offset: const Offset(
                            //                                     0,
                            //                                     3), // changes position of shadow
                            //                               ),
                            //                             ],
                            //                           ),
                            //                           child: TextField(
                            //                             keyboardType:
                            //                                 TextInputType
                            //                                     .number,
                            //                             inputFormatters: <
                            //                                 TextInputFormatter>[
                            //                               FilteringTextInputFormatter
                            //                                   .digitsOnly
                            //                             ],
                            //                             minLines: 1,
                            //                             maxLength: 10,
                            //                             controller:
                            //                                 _phoneController,
                            //                             textAlignVertical:
                            //                                 TextAlignVertical
                            //                                     .center,
                            //                             textAlign:
                            //                                 TextAlign.center,
                            //                             style: TextStyle(
                            //                               color: Colors.black87,
                            //                               fontFamily:
                            //                                   defaultFontFamily,
                            //                             ),
                            //                             decoration: const InputDecoration(
                            //                                 counter: SizedBox.shrink(),
                            //                                 border: InputBorder.none,
                            //                                 // prefixIcon: Container(
                            //                                 //   padding:
                            //                                 //   EdgeInsets.all(11),
                            //                                 //   height: 15,
                            //                                 //   width: 15,
                            //                                 //   child: Image.asset(
                            //                                 //     'assets/icons/icons/email.png',
                            //                                 //   ),
                            //                                 // ),
                            //                                 hintText: "  Enter 10 Digit Mobile Number",
                            //                                 filled: false,
                            //                                 // fillColor: LightColor.yboxbackpurple,
                            //                                 hintStyle: TextStyle(
                            //                                     fontSize: 14,
                            //                                     // fontFamily:
                            //                                     // defaultFontFamily,
                            //                                     color: Colors.grey)),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Padding(
                            //                         padding: const EdgeInsets
                            //                             .fromLTRB(0, 20, 0, 10),
                            //                         child: Row(
                            //                           mainAxisAlignment:
                            //                               MainAxisAlignment
                            //                                   .center,
                            //                           children: [
                            //                             Padding(
                            //                               padding:
                            //                                   const EdgeInsets
                            //                                           .fromLTRB(
                            //                                       30, 0, 0, 0),
                            //                               child: Theme(
                            //                                 data: Theme.of(
                            //                                         context)
                            //                                     .copyWith(
                            //                                   unselectedWidgetColor:
                            //                                       Colors.grey,
                            //                                 ),
                            //                                 child: Checkbox(
                            //                                   checkColor: Colors
                            //                                       .blueAccent,
                            //                                   activeColor:
                            //                                       Colors.white,
                            //                                   value:
                            //                                       _policyChecked,
                            //                                   onChanged:
                            //                                       (value) {
                            //                                     setState(() =>
                            //                                         _policyChecked =
                            //                                             value!);
                            //                                   },
                            //                                 ),
                            //                               ),
                            //                             ),
                            //                             Flexible(
                            //                               child: FadeAnimation(
                            //                                   1.1,
                            //                                   Padding(
                            //                                     padding:
                            //                                         const EdgeInsets
                            //                                                 .fromLTRB(
                            //                                             10,
                            //                                             0,
                            //                                             40,
                            //                                             0),
                            //                                     child: Text(
                            //                                       "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                            //                                       textAlign:
                            //                                           TextAlign
                            //                                               .left,
                            //                                       maxLines: 9,
                            //                                       style: TextStyle(
                            //                                           fontFamily:
                            //                                               defaultFontFamily,
                            //                                           color: Colors
                            //                                               .blueAccent,
                            //                                           fontWeight:
                            //                                               FontWeight
                            //                                                   .normal,
                            //                                           fontSize:
                            //                                               10),
                            //                                     ),
                            //                                   )),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       InkWell(
                            //                         onTap: () {
                            //                           HapticFeedback.vibrate();
                            //                           if (_nameController
                            //                                   .text ==
                            //                               "") {
                            //                             showSnackBar(
                            //                                 "Please Enter Name");
                            //                           } else if (_phoneController
                            //                                   .text ==
                            //                               "") {
                            //                             showSnackBar(
                            //                                 "Please Enter Phone Number");
                            //                           } else if (!_policyChecked) {
                            //                             showSnackBar(
                            //                                 "Please Accept the policy ");
                            //                           } else if (int.tryParse(
                            //                                   _phoneController
                            //                                       .text) ==
                            //                               null) {
                            //                             showSnackBar(
                            //                                 "Only Number are allowed");
                            //                           } else {
                            //                             showSnackBar(
                            //                                 "Processing...");
                            //                             _submitPhoneNumber();
                            //                           }
                            //                         },
                            //                         child: Container(
                            //                           margin: const EdgeInsets
                            //                                   .fromLTRB(
                            //                               40, 10, 40, 20),
                            //
                            //                           // height: height_size - 360,
                            //                           // width: width_size - 470,
                            //                           height: 50,
                            //                           //width: 260,
                            //                           decoration: BoxDecoration(
                            //                             color:
                            //                                 LightColor.appBlue,
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(10),
                            //                           ),
                            //                           child: Center(
                            //                             child: Text(
                            //                               'Enter the zone',
                            //                               style: TextStyle(
                            //                                   fontSize: 16,
                            //                                   fontFamily:
                            //                                       defaultFontFamily,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold,
                            //                                   color:
                            //                                       Colors.white),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 )
                            //               : Container(
                            //                   decoration: BoxDecoration(
                            //                     color: Colors.white,
                            //                     border: Border.all(
                            //                         color: Colors
                            //                             .white, // Set border color
                            //                         width: 0.2),
                            //                     borderRadius:
                            //                         BorderRadius.circular(15),
                            //                   ),
                            //                   margin: const EdgeInsets.fromLTRB(
                            //                       40, 10, 40, 10),
                            //                   child: Column(
                            //                     children: [
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       Align(
                            //                         alignment:
                            //                             Alignment.topLeft,
                            //                         child: Row(
                            //                           children: [
                            //                             IconButton(
                            //                               icon: const Icon(
                            //                                   Icons
                            //                                       .arrow_back_ios,
                            //                                   color:
                            //                                       Colors.grey),
                            //                               onPressed: () {
                            //                                 HapticFeedback
                            //                                     .vibrate();
                            //
                            //                                 setState(() {
                            //                                   _otpSent = false;
                            //                                   //_timer.cancel();
                            //                                   _timeout = false;
                            //                                   _firstDigitOtp
                            //                                       .clear();
                            //                                   _secondDigitOtp
                            //                                       .clear();
                            //                                   _thirdDigitOtp
                            //                                       .clear();
                            //                                   _fourthDigitOtp
                            //                                       .clear();
                            //                                   _fifthDigitOtp
                            //                                       .clear();
                            //                                   _sixthDigitOtp
                            //                                       .clear();
                            //                                 });
                            //                               },
                            //                             ),
                            //                             // Text(
                            //                             //   "Back",
                            //                             //   textAlign:
                            //                             //   TextAlign.left,
                            //                             //   style: TextStyle(
                            //                             //       fontFamily:
                            //                             //       defaultFontFamily,
                            //                             //       color: Colors
                            //                             //           .blueAccent,
                            //                             //       fontWeight:
                            //                             //       FontWeight
                            //                             //           .normal,
                            //                             //       fontSize: 18),
                            //                             // ),
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 5,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 const EdgeInsets
                            //                                         .fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               children: [
                            //                                 Text(
                            //                                   "Mobile Verification",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 18),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 const EdgeInsets
                            //                                         .fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment
                            //                                       .start,
                            //                               children: [
                            //                                 Text(
                            //                                   "Enter 06 Digit OTP",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 12),
                            //                                 ),
                            //                                 const Spacer(),
                            //                                 Padding(
                            //                                   padding:
                            //                                       const EdgeInsets
                            //                                               .fromLTRB(
                            //                                           0,
                            //                                           0,
                            //                                           40,
                            //                                           0),
                            //                                   child: Text(
                            //                                     "",
                            //                                     // _start.toString() ==
                            //                                     //     "0"
                            //                                     //     ? ''
                            //                                     //     : '$_start',
                            //                                     textAlign:
                            //                                         TextAlign
                            //                                             .left,
                            //                                     style: TextStyle(
                            //                                         fontFamily: defaultFontFamily,
                            //                                         color: Colors.blueAccent,
                            //                                         //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                         fontWeight: FontWeight.normal,
                            //                                         fontSize: 12),
                            //                                   ),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       FadeAnimation(
                            //                         0.5,
                            //                         Row(
                            //                           children: [
                            //                             const SizedBox(
                            //                               width: 35,
                            //                             ),
                            //                             OtpInput(_firstDigitOtp,
                            //                                 true),
                            //                             OtpInput(
                            //                                 _secondDigitOtp,
                            //                                 false),
                            //                             OtpInput(_thirdDigitOtp,
                            //                                 false),
                            //                             OtpInput(
                            //                                 _fourthDigitOtp,
                            //                                 false),
                            //                             OtpInput(_fifthDigitOtp,
                            //                                 false),
                            //                             OtpInput(_sixthDigitOtp,
                            //                                 false),
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           InkWell(
                            //                             onTap: () {
                            //                               if (_timeout) {
                            //                                 setState(() {
                            //                                   _timeout = false;
                            //                                   // _timer.cancel();
                            //                                 });
                            //                                 HapticFeedback
                            //                                     .vibrate();
                            //                                 // startTimer();
                            //                                 _resubmitPhoneNumber();
                            //                               } else {
                            //                                 showSnackBar(
                            //                                     "OTP already sent");
                            //                               }
                            //                             },
                            //                             child: Padding(
                            //                               padding:
                            //                                   const EdgeInsets
                            //                                           .fromLTRB(
                            //                                       0, 0, 0, 0),
                            //                               child: Row(
                            //                                 mainAxisAlignment:
                            //                                     MainAxisAlignment
                            //                                         .center,
                            //                                 children: [
                            //                                   Text(
                            //                                     _timeout
                            //                                         ? "Resend Otp"
                            //                                         : "Didn't receive OTP! Resend in 2 minutes",
                            //                                     style: TextStyle(
                            //                                         fontFamily:
                            //                                             defaultFontFamily,
                            //                                         color: _timeout
                            //                                             ? Colors
                            //                                                 .blueAccent
                            //                                             : Colors
                            //                                                 .grey,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         fontSize:
                            //                                             10),
                            //                                   ),
                            //                                 ],
                            //                               ),
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 40,
                            //                       ),
                            //                       InkWell(
                            //                         onTap: () {
                            //                           HapticFeedback.vibrate();
                            //                           _submitOTP(
                            //                               verification_id);
                            //
                            //                           //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
                            //
                            //                           //   Navigator.of(context).push(_createRoute());
                            //
                            //                           // Navigator.push(
                            //                           //   context,
                            //                           //   MaterialPageRoute(
                            //                           //       builder: (context) => ZoneScreen()),
                            //                           // );
                            //                         },
                            //                         child: Container(
                            //                           margin: const EdgeInsets
                            //                                   .fromLTRB(
                            //                               50, 10, 50, 20),
                            //
                            //                           // height: height_size - 360,
                            //                           // width: width_size - 470,
                            //                           height: 50,
                            //                           //width: 260,
                            //                           decoration:
                            //                               const BoxDecoration(
                            //                             color:
                            //                                 Colors.blueAccent,
                            //                             borderRadius:
                            //                                 BorderRadius.only(
                            //                                     topRight: Radius
                            //                                         .circular(
                            //                                             20.0),
                            //                                     bottomRight:
                            //                                         Radius.circular(
                            //                                             20.0),
                            //                                     topLeft: Radius
                            //                                         .circular(
                            //                                             20.0),
                            //                                     bottomLeft: Radius
                            //                                         .circular(
                            //                                             20.0)),
                            //                             // boxShadow: [
                            //                             //   BoxShadow(
                            //                             //     color:
                            //                             //     Colors.black.withOpacity(0.4),
                            //                             //     spreadRadius: 10,
                            //                             //     blurRadius: 9,
                            //                             //     offset: const Offset(0,
                            //                             //         3), // changes position of shadow
                            //                             //   ),
                            //                             // ],
                            //                           ),
                            //                           child: Center(
                            //                             child: Text(
                            //                               'Continue',
                            //                               style: TextStyle(
                            //                                   fontSize: 16,
                            //                                   fontFamily:
                            //                                       defaultFontFamily,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold,
                            //                                   color:
                            //                                       Colors.white),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               const SizedBox(
                            //                 width: 40,
                            //               ),
                            //
                            //               // ShakeAnimatedWidget(
                            //               //   enabled: true,
                            //               //   duration: const Duration(milliseconds: 450),
                            //               //   shakeAngle: Rotation.deg(z: 4),
                            //               //   curve: Curves.linear,
                            //               //   child: InkWell(
                            //               //     onTap: () {
                            //               //       Navigator.push(
                            //               //         context,
                            //               //         MaterialPageRoute(
                            //               //             builder: (context) => const ChessGame()),
                            //               //       );
                            //               //     },
                            //               //     child: Container(
                            //               //       margin: const EdgeInsets.all(10),
                            //               //       // height: height_size - 320,
                            //               //       // width: width_size - 665,
                            //               //
                            //               //       height: 120,
                            //               //       width: 100,
                            //               //       decoration: const BoxDecoration(
                            //               //         image: DecorationImage(
                            //               //           image: AssetImage("assets/games/Chesss.png"),
                            //               //           fit: BoxFit.fill,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //
                            //               // ShakeAnimatedWidget(
                            //               //   enabled: true,
                            //               //   duration: Duration(milliseconds: 450),
                            //               //   shakeAngle: Rotation.deg(z: 4),
                            //               //   curve: Curves.linear,
                            //               //   child: InkWell(
                            //               //     onTap: () {
                            //               //       Navigator.push(
                            //               //         context,
                            //               //         MaterialPageRoute(
                            //               //             // builder: (context) => ChessGame()),
                            //               //             builder: (context) => SplashScrenn()),
                            //               //       );
                            //               //     },
                            //               //     child: Container(
                            //               //       margin: const EdgeInsets.all(10),
                            //               //       height: 80,
                            //               //       width: 65,
                            //               //       decoration: const BoxDecoration(
                            //               //         image: DecorationImage(
                            //               //           image: AssetImage(
                            //               //               "assets/games/Covi KIll.png"),
                            //               //           fit: BoxFit.fill,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //
                            //               ShakeAnimatedWidget(
                            //                 enabled: true,
                            //                 duration:
                            //                     Duration(milliseconds: 450),
                            //                 shakeAngle: Rotation.deg(z: 4),
                            //                 curve: Curves.linear,
                            //                 child: InkWell(
                            //                   onTap: () {
                            //                     HapticFeedback.vibrate();
                            //                     _otpSent
                            //                         ? showSnackBar(
                            //                             "Please Click on Continue !")
                            //                         : showSnackBar(
                            //                             "Please Click on the Enter The Zone !");
                            //                     // Navigator.push(
                            //                     //   context,
                            //                     //   MaterialPageRoute(
                            //                     //       // builder: (context) => ChessGame()),
                            //                     //       builder: (context) =>
                            //                     //           const FunFacts_Screen()),
                            //                     // );
                            //                   },
                            //                   child: Container(
                            //                     margin:
                            //                         const EdgeInsets.all(10),
                            //                     height: 80,
                            //                     width: 65,
                            //                     decoration: const BoxDecoration(
                            //                       image: DecorationImage(
                            //                         image: AssetImage(
                            //                             "assets/games/Fun Facts.png"),
                            //                         fit: BoxFit.fill,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //
                            //               ShakeAnimatedWidget(
                            //                 enabled: true,
                            //                 duration:
                            //                     Duration(milliseconds: 450),
                            //                 shakeAngle: Rotation.deg(z: 4),
                            //                 curve: Curves.linear,
                            //                 child: InkWell(
                            //                   onTap: () {
                            //                     HapticFeedback.vibrate();
                            //                     _otpSent
                            //                         ? showSnackBar(
                            //                             "Please Click on Continue !")
                            //                         : showSnackBar(
                            //                             "Please Click on the Enter The Zone !");
                            //                     // Navigator.push(
                            //                     //   context,
                            //                     //   MaterialPageRoute(
                            //                     //       // builder: (context) => ChessGame()),
                            //                     //       builder: (context) =>
                            //                     //           const Quiz_Screen()),
                            //                     // );
                            //                   },
                            //                   child: Container(
                            //                     margin:
                            //                         const EdgeInsets.all(10),
                            //                     height: 80,
                            //                     width: 65,
                            //                     decoration: const BoxDecoration(
                            //                       image: DecorationImage(
                            //                         image: AssetImage(
                            //                             "assets/games/Quiz Time.png"),
                            //                         fit: BoxFit.fill,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //
                            //               const SizedBox(
                            //                 width: 40,
                            //               ),
                            //             ],
                            //           ),
                            //           const SizedBox(
                            //             height: 30,
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   )
                            ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
// height: 70,
// width: 160,
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
// height: 50,
// width: 100,
                                      padding: const EdgeInsets.fromLTRB(
                                          80, 20, 80, 20),
// padding: const EdgeInsets.fromLTRB(
//     60, 15, 60, 15),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/site-logo.png"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      child: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                              child: Text(
                                "SUD Life Experience Zone",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: defaultFontFamily,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
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
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                                            AssetImage(user.icon),size: 25,color: Colors.red,)
                                              : Container(),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            user.name,
                                            style:
                                            TextStyle(color: LightColor.appBlue,fontSize: 16),
                                          ),

                                          //Divider(height: 1,thickness: 2,color: Colors.black),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  underline: DropdownButtonHideUnderline(
                                      child: Container()),
                                  onChanged: (newValue) {
                                    newValue = newValue as Item;
                                    if (newValue.name == "Pay Premium") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Pay Premium',
                                                  url_link:
                                                  'https://www.sudlife.in/customer-service/premium-payment-options')));
                                    } else if (newValue.name ==
                                        "Buy Online") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Buy Online',
                                                  url_link:
                                                  'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')));
                                    } else if (newValue.name ==
                                        "Insurance Plan") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Insurance Plans',
                                                  url_link:
                                                  'https://www.sudlife.in/products/life-insurance')));
                                    } else if (newValue.name ==
                                        "Calculate Premium") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Calculate Premiums',
                                                  url_link:
                                                  'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')));
                                    } else if (newValue.name == "Claims") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Claims',
                                                  url_link:
                                                  'https://www.sudlife.in/claims')));
                                    } else if (newValue.name ==
                                        "Customer Portal") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Customer Portal',
                                                  url_link:
                                                  'https://www.sudlife.in/contact-us')));
                                    } else {}
                                    setState(() {
                                      // dropdownValue = newValue! as Item;
                                    });
                                  },
                                  // onChanged: (value) {
                                  //   print(value);
                                  //   setState(() {
                                  //     itemValue = value as Item;
                                  //   });
                                  // },
                                ),
                                // child: DropdownButton<String>(
                                //   dropdownColor: Colors.white,
                                //   iconSize: 24,
                                //   elevation: 16,
                                //   isExpanded: true,
                                //   value: dropdownValue,
                                //   iconEnabledColor: LightColor.appBlue,
                                //   hint: Text(
                                //     'Self-Help',
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                //   icon: const Icon(
                                //       Icons.keyboard_arrow_down_rounded),
                                //   borderRadius: BorderRadius.circular(7.0),
                                //   style: TextStyle(
                                //       color: LightColor.appBlue,
                                //       fontWeight: FontWeight.w600),
                                //   items: items.map<DropdownMenuItem<String>>(
                                //       (String value) {
                                //     return DropdownMenuItem<String>(
                                //       value: value,
                                //       child: Text(value),
                                //     );
                                //   }).toList(),
                                //   underline: DropdownButtonHideUnderline(
                                //       child: Container()),
                                //   onChanged: (String? newValue) {
                                //     if (newValue == "Pay Premium") {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => WebViewScreen(
                                //                   key: _scaffoldKey,
                                //                   title: 'Pay Premium',
                                //                   url_link:
                                //                       'https://www.sudlife.in/customer-service/premium-payment-options')));
                                //     } else if (newValue ==
                                //         "Insurance Plans") {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => WebViewScreen(
                                //                   key: _scaffoldKey,
                                //                   title: 'Insurance Plans',
                                //                   url_link:
                                //                       'https://www.sudlife.in/products/life-insurance')));
                                //     } else if (newValue ==
                                //         "Calculate Premiums") {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => WebViewScreen(
                                //                   key: _scaffoldKey,
                                //                   title: 'Calculate Premiums',
                                //                   url_link:
                                //                       'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')));
                                //     } else if (newValue == "Claims") {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => WebViewScreen(
                                //                   key: _scaffoldKey,
                                //                   title: 'Claims',
                                //                   url_link:
                                //                       'https://www.sudlife.in/claims')));
                                //     } else if (newValue ==
                                //         "Customer Portal") {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => WebViewScreen(
                                //                   key: _scaffoldKey,
                                //                   title: 'Customer Portal',
                                //                   url_link:
                                //                       'https://www.sudlife.in/contact-us')));
                                //     } else {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => WebViewScreen(
                                //                   key: _scaffoldKey,
                                //                   title: 'Buy Online',
                                //                   url_link:
                                //                       'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')));
                                //     }
                                //
                                //     setState(() {
                                //       dropdownValue = newValue!;
                                //     });
                                //   },
                                // ),
                              ),
                            ),
                            SizedBox(
                              height: 370.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      gameBox(
                                          context,
                                          gameList[index].url,
                                          gameList[index].name,
                                          gameList[index].image_url),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 0, 40, 0),
                                    child: Container(
                                      height: 45,
                                      width: 180,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0)),
                                          side: const BorderSide(
                                            width: 2,
                                            color: Color(0xff0F5A93),
                                          ),
                                        ),
                                        child: Text( FirebaseAuth.instance.currentUser != null
                                           ? "Exit" : "Login" ,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        onPressed: () async {
                                          FirebaseAuth.instance.currentUser != null
                                              ? _showMyDialog()
                                              : loginView(context);
                                          //_showMyDialog();
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 30, 0, 30),
                                    child: Text(
                                      "Protecting Families, Enriching Lives",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: defaultFontFamily,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )

                            // : Column(
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           children: [
                            //             Container(
                            //               // height: 70,
                            //               // width: 160,
                            //               padding: const EdgeInsets.all(14),
                            //               decoration: const BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius: BorderRadius.only(
                            //                     topRight: Radius.circular(15.0),
                            //                     bottomRight:
                            //                         Radius.circular(15.0),
                            //                     topLeft: Radius.circular(15.0),
                            //                     bottomLeft:
                            //                         Radius.circular(15.0)),
                            //               ),
                            //               child: Container(
                            //                 // height: 50,
                            //                 // width: 100,
                            //                 padding: const EdgeInsets.fromLTRB(
                            //                     60, 20, 60, 20),
                            //                 decoration: const BoxDecoration(
                            //                   color: Colors.white,
                            //                   image: DecorationImage(
                            //                     image: AssetImage(
                            //                         "assets/images/site-logo.png"),
                            //                     fit: BoxFit.contain,
                            //                   ),
                            //                 ),
                            //                 child: null,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Spacer(),
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.center,
                            //         mainAxisSize: MainAxisSize.max,
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         children: [
                            //           // InkWell(
                            //           //   onTap: () {
                            //           //     Navigator.of(context).push(
                            //           //         PageRouteBuilder(
                            //           //             pageBuilder: (context,
                            //           //                 animation,
                            //           //                 secondaryAnimation) {
                            //           //               return ZoneHomeScreen();
                            //           //             },
                            //           //             transitionDuration:
                            //           //                 const Duration(
                            //           //                     milliseconds: 500),
                            //           //             transitionsBuilder: (context,
                            //           //                 animation,
                            //           //                 secondaryAnimation,
                            //           //                 child) {
                            //           //               return FadeTransition(
                            //           //                 opacity: animation,
                            //           //                 child: child,
                            //           //               );
                            //           //             }));
                            //           //
                            //           //     //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
                            //           //
                            //           //     //   Navigator.of(context).push(_createRoute());
                            //           //
                            //           //     // Navigator.push(
                            //           //     //   context,
                            //           //     //   MaterialPageRoute(
                            //           //     //       builder: (context) => ZoneScreen()),
                            //           //     // );
                            //           //   },
                            //           //   child: Container(
                            //           //     margin: const EdgeInsets.all(10),
                            //           //     // height: height_size - 360,
                            //           //     // width: width_size - 470,
                            //           //     height: 60,
                            //           //     width: 160,
                            //           //     decoration: BoxDecoration(
                            //           //       color: Colors.white,
                            //           //       borderRadius: const BorderRadius.only(
                            //           //           topRight: Radius.circular(20.0),
                            //           //           bottomRight:
                            //           //               Radius.circular(20.0),
                            //           //           topLeft: Radius.circular(20.0),
                            //           //           bottomLeft:
                            //           //               Radius.circular(20.0)),
                            //           //       boxShadow: [
                            //           //         BoxShadow(
                            //           //           color:
                            //           //               Colors.black.withOpacity(0.4),
                            //           //           spreadRadius: 10,
                            //           //           blurRadius: 9,
                            //           //           offset: const Offset(0,
                            //           //               3), // changes position of shadow
                            //           //         ),
                            //           //       ],
                            //           //     ),
                            //           //     child: Center(
                            //           //       child: Text(
                            //           //         'Enter the zone',
                            //           //         style: TextStyle(
                            //           //             fontSize: 16,
                            //           //             fontFamily: defaultFontFamily,
                            //           //             fontWeight: FontWeight.bold,
                            //           //             color:
                            //           //                 Colors.blueAccent.shade400),
                            //           //       ),
                            //           //     ),
                            //           //   ),
                            //           // ),
                            //
                            //           !_otpSent
                            //               ? Container(
                            //                   decoration: BoxDecoration(
                            //                     color: Colors.white,
                            //                     border: Border.all(
                            //                         color: Colors
                            //                             .white, // Set border color
                            //                         width: 0.2),
                            //                     borderRadius:
                            //                         BorderRadius.circular(15),
                            //                   ),
                            //                   margin: EdgeInsets.fromLTRB(
                            //                       40, 10, 40, 10),
                            //                   child: Column(
                            //                     children: [
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               children: [
                            //                                 Text(
                            //                                   "Enter Your Details",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 18),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment
                            //                                       .start,
                            //                               children: [
                            //                                 Text(
                            //                                   "Name",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 15),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       FadeAnimation(
                            //                         0.5,
                            //                         Container(
                            //                           height: 53,
                            //                           // width: MediaQuery.of(context)
                            //                           //     .size
                            //                           //     .width -
                            //                           //     180,
                            //                           margin:
                            //                               EdgeInsets.fromLTRB(
                            //                                   40, 0, 40, 0),
                            //                           decoration: BoxDecoration(
                            //                             color: Colors.white,
                            //                             border: Border.all(
                            //                                 color: (Colors.grey[
                            //                                     800])!, // Set border color
                            //                                 width: 0.2),
                            //                             // gradient: const LinearGradient(
                            //                             //   // begin: Alignment.centerLeft,
                            //                             //   // end: Alignment.centerRight,
                            //                             //   colors: <Color>[
                            //                             //     Color.fromRGBO(
                            //                             //         255, 241, 255, 1.0),
                            //                             //     Color.fromRGBO(
                            //                             //         243, 231, 255, 1.0),
                            //                             //   ],
                            //                             // ),
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(10),
                            //                             boxShadow: [
                            //                               BoxShadow(
                            //                                 color: Colors.grey
                            //                                     .withOpacity(
                            //                                         0.3),
                            //                                 spreadRadius: 1,
                            //                                 blurRadius: 19,
                            //                                 offset: const Offset(
                            //                                     0,
                            //                                     3), // changes position of shadow
                            //                               ),
                            //                             ],
                            //                           ),
                            //                           child: TextField(
                            //                             controller:
                            //                                 _nameController,
                            //                             minLines: 1,
                            //                             maxLength: 30,
                            //                             inputFormatters: <
                            //                                 TextInputFormatter>[
                            //                               FilteringTextInputFormatter
                            //                                   .allow(RegExp(
                            //                                       "[a-z A-Z]")),
                            //                             ],
                            //                             textAlignVertical:
                            //                                 TextAlignVertical
                            //                                     .center,
                            //                             textAlign:
                            //                                 TextAlign.center,
                            //                             style: TextStyle(
                            //                               color: Colors.black87,
                            //                               fontFamily:
                            //                                   defaultFontFamily,
                            //                             ),
                            //                             decoration: const InputDecoration(
                            //                                 border: InputBorder.none,
                            //                                 hintText: "  Enter Your Full Name",
                            //                                 filled: false,
                            //                                 hintStyle: TextStyle(
                            //                                     fontSize: 14,
                            //                                     // fontFamily:
                            //                                     // defaultFontFamily,
                            //                                     color: Colors.grey)),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment
                            //                                       .start,
                            //                               children: [
                            //                                 Text(
                            //                                   "Mobile Number",
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 15),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       FadeAnimation(
                            //                         0.5,
                            //                         Container(
                            //                           height: 53,
                            //                           // width: MediaQuery.of(context)
                            //                           //     .size
                            //                           //     .width -
                            //                           //     180,
                            //                           margin:
                            //                               EdgeInsets.fromLTRB(
                            //                                   40, 0, 40, 0),
                            //                           decoration: BoxDecoration(
                            //                             color: Colors.white,
                            //                             border: Border.all(
                            //                                 color: (Colors.grey[
                            //                                     800])!, // Set border color
                            //                                 width: 0.2),
                            //                             // gradient: const LinearGradient(
                            //                             //   // begin: Alignment.centerLeft,
                            //                             //   // end: Alignment.centerRight,
                            //                             //   colors: <Color>[
                            //                             //     Color.fromRGBO(
                            //                             //         255, 241, 255, 1.0),
                            //                             //     Color.fromRGBO(
                            //                             //         243, 231, 255, 1.0),
                            //                             //   ],
                            //                             // ),
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(10),
                            //                             boxShadow: [
                            //                               BoxShadow(
                            //                                 color: Colors.grey
                            //                                     .withOpacity(
                            //                                         0.3),
                            //                                 spreadRadius: 1,
                            //                                 blurRadius: 19,
                            //                                 offset: const Offset(
                            //                                     0,
                            //                                     3), // changes position of shadow
                            //                               ),
                            //                             ],
                            //                           ),
                            //                           child: TextField(
                            //                             minLines: 1,
                            //                             controller:
                            //                                 _phoneController,
                            //                             textAlignVertical:
                            //                                 TextAlignVertical
                            //                                     .center,
                            //                             textAlign:
                            //                                 TextAlign.center,
                            //                             style: TextStyle(
                            //                               color: Colors.black87,
                            //                               fontFamily:
                            //                                   defaultFontFamily,
                            //                             ),
                            //                             decoration: const InputDecoration(
                            //                                 border: InputBorder.none,
                            //                                 // prefixIcon: Container(
                            //                                 //   padding:
                            //                                 //   EdgeInsets.all(11),
                            //                                 //   height: 15,
                            //                                 //   width: 15,
                            //                                 //   child: Image.asset(
                            //                                 //     'assets/icons/icons/email.png',
                            //                                 //   ),
                            //                                 // ),
                            //                                 hintText: "  Enter 10 Digit Mobile Number",
                            //                                 filled: false,
                            //                                 // fillColor: LightColor.yboxbackpurple,
                            //                                 hintStyle: TextStyle(
                            //                                     fontSize: 14,
                            //                                     // fontFamily:
                            //                                     // defaultFontFamily,
                            //                                     color: Colors.grey)),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Padding(
                            //                         padding:
                            //                             EdgeInsets.fromLTRB(
                            //                                 0, 20, 0, 10),
                            //                         child: Row(
                            //                           mainAxisAlignment:
                            //                               MainAxisAlignment
                            //                                   .center,
                            //                           children: [
                            //                             Padding(
                            //                               padding: EdgeInsets
                            //                                   .fromLTRB(
                            //                                       30, 0, 0, 0),
                            //                               child: Theme(
                            //                                 data: Theme.of(
                            //                                         context)
                            //                                     .copyWith(
                            //                                   unselectedWidgetColor:
                            //                                       Colors.grey,
                            //                                 ),
                            //                                 child: Checkbox(
                            //                                   checkColor: Colors
                            //                                       .blueAccent,
                            //                                   activeColor:
                            //                                       Colors.white,
                            //                                   value:
                            //                                       _policyChecked,
                            //                                   onChanged:
                            //                                       (value) {
                            //                                     setState(() =>
                            //                                         _policyChecked =
                            //                                             value!);
                            //                                   },
                            //                                 ),
                            //                               ),
                            //                             ),
                            //                             Expanded(
                            //                               child: FadeAnimation(
                            //                                   1.1,
                            //                                   Padding(
                            //                                     padding:
                            //                                         EdgeInsets
                            //                                             .fromLTRB(
                            //                                                 10,
                            //                                                 0,
                            //                                                 40,
                            //                                                 0),
                            //                                     child: Text(
                            //                                       "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                            //                                       textAlign:
                            //                                           TextAlign
                            //                                               .left,
                            //                                       maxLines: 6,
                            //                                       style: TextStyle(
                            //                                           fontFamily:
                            //                                               defaultFontFamily,
                            //                                           color: Colors
                            //                                               .blueAccent,
                            //                                           fontWeight:
                            //                                               FontWeight
                            //                                                   .normal,
                            //                                           fontSize:
                            //                                               10),
                            //                                     ),
                            //                                   )),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       InkWell(
                            //                         onTap: () {
                            //                           HapticFeedback.vibrate();
                            //                           if (_nameController
                            //                                   .text ==
                            //                               "") {
                            //                             showSnackBar(
                            //                                 "Please Enter Name");
                            //                           } else if (_phoneController
                            //                                   .text ==
                            //                               "") {
                            //                             showSnackBar(
                            //                                 "Please Enter Phone Number");
                            //                           } else if (!_policyChecked) {
                            //                             showSnackBar(
                            //                                 "Please Accept the policy ");
                            //                           } else if (int.tryParse(
                            //                                   _phoneController
                            //                                       .text) ==
                            //                               null) {
                            //                             showSnackBar(
                            //                                 "Only Number are allowed");
                            //                           } else {
                            //                             showSnackBar(
                            //                                 "Processing...");
                            //                             _submitPhoneNumber();
                            //                           }
                            //
                            //                           // if (_nameController.text ==
                            //                           //     "") {
                            //                           //   showSnackBar("Enter Name");
                            //                           // } else if (_phoneController
                            //                           //         .text ==
                            //                           //     "") {
                            //                           //   showSnackBar(
                            //                           //       "Enter Phone Number");
                            //                           // } else {
                            //                           //
                            //                           //   _submitPhoneNumber();
                            //                           // }
                            //                         },
                            //                         child: Container(
                            //                           margin: const EdgeInsets
                            //                                   .fromLTRB(
                            //                               40, 10, 40, 20),
                            //
                            //                           // height: height_size - 360,
                            //                           // width: width_size - 470,
                            //                           height: 50,
                            //                           //width: 260,
                            //                           decoration:
                            //                               const BoxDecoration(
                            //                             color:
                            //                                 Colors.blueAccent,
                            //                             borderRadius:
                            //                                 BorderRadius.only(
                            //                                     topRight: Radius
                            //                                         .circular(
                            //                                             20.0),
                            //                                     bottomRight:
                            //                                         Radius.circular(
                            //                                             20.0),
                            //                                     topLeft: Radius
                            //                                         .circular(
                            //                                             20.0),
                            //                                     bottomLeft: Radius
                            //                                         .circular(
                            //                                             20.0)),
                            //                             // boxShadow: [
                            //                             //   BoxShadow(
                            //                             //     color:
                            //                             //     Colors.black.withOpacity(0.4),
                            //                             //     spreadRadius: 10,
                            //                             //     blurRadius: 9,
                            //                             //     offset: const Offset(0,
                            //                             //         3), // changes position of shadow
                            //                             //   ),
                            //                             // ],
                            //                           ),
                            //                           child: Center(
                            //                             child: Text(
                            //                               'Enter the zone',
                            //                               style: TextStyle(
                            //                                   fontSize: 16,
                            //                                   fontFamily:
                            //                                       defaultFontFamily,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold,
                            //                                   color:
                            //                                       Colors.white),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 )
                            //               : Container(
                            //                   decoration: BoxDecoration(
                            //                     color: Colors.white,
                            //                     border: Border.all(
                            //                         color: Colors
                            //                             .white, // Set border color
                            //                         width: 0.2),
                            //                     borderRadius:
                            //                         BorderRadius.circular(15),
                            //                   ),
                            //                   margin: const EdgeInsets.fromLTRB(
                            //                       40, 10, 40, 10),
                            //                   child: Column(
                            //                     children: [
                            //                       // const SizedBox(
                            //                       //   height: 20,
                            //                       // ),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       Align(
                            //                         alignment:
                            //                             Alignment.topLeft,
                            //                         child: Row(
                            //                           children: [
                            //                             IconButton(
                            //                               icon: const Icon(
                            //                                   Icons
                            //                                       .arrow_back_ios,
                            //                                   color:
                            //                                       Colors.grey),
                            //                               onPressed: () {
                            //                                 HapticFeedback
                            //                                     .vibrate();
                            //
                            //                                 setState(() {
                            //                                   _otpSent = false;
                            //                                   //_timer.cancel();
                            //                                   _timeout = false;
                            //                                   _firstDigitOtp
                            //                                       .clear();
                            //                                   _secondDigitOtp
                            //                                       .clear();
                            //                                   _thirdDigitOtp
                            //                                       .clear();
                            //                                   _fourthDigitOtp
                            //                                       .clear();
                            //                                   _fifthDigitOtp
                            //                                       .clear();
                            //                                   _sixthDigitOtp
                            //                                       .clear();
                            //                                 });
                            //                               },
                            //                             ),
                            //                             // Text(
                            //                             //   "Back",
                            //                             //   textAlign:
                            //                             //   TextAlign.left,
                            //                             //   style: TextStyle(
                            //                             //       fontFamily:
                            //                             //       defaultFontFamily,
                            //                             //       color: Colors
                            //                             //           .blueAccent,
                            //                             //       fontWeight:
                            //                             //       FontWeight
                            //                             //           .normal,
                            //                             //       fontSize: 18),
                            //                             // ),
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 5,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               children: [
                            //                                 Text(
                            //                                   "Mobile Verification",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 18),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           Padding(
                            //                             padding:
                            //                                 const EdgeInsets
                            //                                         .fromLTRB(
                            //                                     40, 0, 0, 0),
                            //                             child: Row(
                            //                               mainAxisAlignment:
                            //                                   MainAxisAlignment
                            //                                       .start,
                            //                               children: [
                            //                                 Text(
                            //                                   "Enter 06 Digit OTP",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .left,
                            //                                   style: TextStyle(
                            //                                       fontFamily:
                            //                                           defaultFontFamily,
                            //                                       color: Colors
                            //                                           .blueAccent,
                            //                                       //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .normal,
                            //                                       fontSize: 12),
                            //                                 ),
                            //                                 Spacer(),
                            //                                 // Padding(
                            //                                 //   padding: EdgeInsets
                            //                                 //       .fromLTRB(
                            //                                 //       0, 0, 40, 0),
                            //                                 //   child: Text(
                            //                                 //     '$_start',
                            //                                 //     textAlign:
                            //                                 //     TextAlign.left,
                            //                                 //     style: TextStyle(
                            //                                 //         fontFamily:
                            //                                 //         defaultFontFamily,
                            //                                 //         color: Colors
                            //                                 //             .blueAccent,
                            //                                 //         //Color.fromRGBO(113, 56, 208, 1.0),
                            //                                 //         fontWeight:
                            //                                 //         FontWeight
                            //                                 //             .normal,
                            //                                 //         fontSize: 12),
                            //                                 //   ),
                            //                                 // ),
                            //                               ],
                            //                             ),
                            //                           )),
                            //                       const SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       FadeAnimation(
                            //                         0.5,
                            //                         Row(
                            //                           children: [
                            //                             const SizedBox(
                            //                               width: 35,
                            //                             ),
                            //                             OtpInput(_firstDigitOtp,
                            //                                 true),
                            //                             OtpInput(
                            //                                 _secondDigitOtp,
                            //                                 false),
                            //                             OtpInput(_thirdDigitOtp,
                            //                                 false),
                            //                             OtpInput(
                            //                                 _fourthDigitOtp,
                            //                                 false),
                            //                             OtpInput(_fifthDigitOtp,
                            //                                 false),
                            //                             OtpInput(_sixthDigitOtp,
                            //                                 false),
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 20,
                            //                       ),
                            //                       FadeAnimation(
                            //                           1.1,
                            //                           InkWell(
                            //                             onTap: () {
                            //                               if (_timeout) {
                            //                                 HapticFeedback
                            //                                     .vibrate();
                            //                                 // startTimer();
                            //                                 _resubmitPhoneNumber();
                            //                               } else {
                            //                                 showSnackBar(
                            //                                     "OTP already Sent");
                            //                               }
                            //                             },
                            //                             child: Padding(
                            //                               padding:
                            //                                   const EdgeInsets
                            //                                           .fromLTRB(
                            //                                       0, 0, 0, 0),
                            //                               child: Row(
                            //                                 mainAxisAlignment:
                            //                                     MainAxisAlignment
                            //                                         .center,
                            //                                 children: [
                            //                                   Text(
                            //                                     _timeout
                            //                                         ? "Resend Otp"
                            //                                         : "Didn't receive OTP! Will Resend in 2 minutes",
                            //                                     style: TextStyle(
                            //                                         fontFamily:
                            //                                             defaultFontFamily,
                            //                                         color: _timeout
                            //                                             ? Colors
                            //                                                 .blueAccent
                            //                                             : Colors
                            //                                                 .grey,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         fontSize:
                            //                                             10),
                            //                                   ),
                            //                                 ],
                            //                               ),
                            //                             ),
                            //                           )),
                            //
                            //                       const SizedBox(
                            //                         height: 40,
                            //                       ),
                            //
                            //                       InkWell(
                            //                         onTap: () {
                            //                           HapticFeedback.vibrate();
                            //                           _submitOTP(
                            //                               verification_id);
                            //                           // Navigator.of(context).push(
                            //                           //     PageRouteBuilder(
                            //                           //         pageBuilder: (context,
                            //                           //             animation,
                            //                           //             secondaryAnimation) {
                            //                           //           return ZoneHomeScreen();
                            //                           //         },
                            //                           //         transitionDuration:
                            //                           //             const Duration(
                            //                           //                 milliseconds:
                            //                           //                     500),
                            //                           //         transitionsBuilder:
                            //                           //             (context,
                            //                           //                 animation,
                            //                           //                 secondaryAnimation,
                            //                           //                 child) {
                            //                           //           return FadeTransition(
                            //                           //             opacity: animation,
                            //                           //             child: child,
                            //                           //           );
                            //                           //         }));
                            //                           //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
                            //
                            //                           //   Navigator.of(context).push(_createRoute());
                            //
                            //                           // Navigator.push(
                            //                           //   context,
                            //                           //   MaterialPageRoute(
                            //                           //       builder: (context) => ZoneScreen()),
                            //                           // );
                            //                         },
                            //                         child: Container(
                            //                           margin: const EdgeInsets
                            //                                   .fromLTRB(
                            //                               50, 10, 50, 20),
                            //
                            //                           // height: height_size - 360,
                            //                           // width: width_size - 470,
                            //                           height: 50,
                            //                           //width: 260,
                            //                           decoration:
                            //                               const BoxDecoration(
                            //                             color:
                            //                                 Colors.blueAccent,
                            //                             borderRadius:
                            //                                 BorderRadius.only(
                            //                                     topRight: Radius
                            //                                         .circular(
                            //                                             20.0),
                            //                                     bottomRight:
                            //                                         Radius.circular(
                            //                                             20.0),
                            //                                     topLeft: Radius
                            //                                         .circular(
                            //                                             20.0),
                            //                                     bottomLeft: Radius
                            //                                         .circular(
                            //                                             20.0)),
                            //                             // boxShadow: [
                            //                             //   BoxShadow(
                            //                             //     color:
                            //                             //     Colors.black.withOpacity(0.4),
                            //                             //     spreadRadius: 10,
                            //                             //     blurRadius: 9,
                            //                             //     offset: const Offset(0,
                            //                             //         3), // changes position of shadow
                            //                             //   ),
                            //                             // ],
                            //                           ),
                            //                           child: Center(
                            //                             child: Text(
                            //                               'Continue',
                            //                               style: TextStyle(
                            //                                   fontSize: 16,
                            //                                   fontFamily:
                            //                                       defaultFontFamily,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold,
                            //                                   color:
                            //                                       Colors.white),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //
                            //           const SizedBox(
                            //             height: 20,
                            //           ),
                            //
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               const SizedBox(
                            //                 width: 40,
                            //               ),
                            //
                            //               // ShakeAnimatedWidget(
                            //               //   enabled: true,
                            //               //   duration: const Duration(milliseconds: 450),
                            //               //   shakeAngle: Rotation.deg(z: 4),
                            //               //   curve: Curves.linear,
                            //               //   child: InkWell(
                            //               //     onTap: () {
                            //               //       Navigator.push(
                            //               //         context,
                            //               //         MaterialPageRoute(
                            //               //             builder: (context) => const ChessGame()),
                            //               //       );
                            //               //     },
                            //               //     child: Container(
                            //               //       margin: const EdgeInsets.all(10),
                            //               //       // height: height_size - 320,
                            //               //       // width: width_size - 665,
                            //               //
                            //               //       height: 120,
                            //               //       width: 100,
                            //               //       decoration: const BoxDecoration(
                            //               //         image: DecorationImage(
                            //               //           image: AssetImage("assets/games/Chesss.png"),
                            //               //           fit: BoxFit.fill,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //
                            //               // ShakeAnimatedWidget(
                            //               //   enabled: true,
                            //               //   duration: Duration(milliseconds: 450),
                            //               //   shakeAngle: Rotation.deg(z: 4),
                            //               //   curve: Curves.linear,
                            //               //   child: InkWell(
                            //               //     onTap: () {
                            //               //       Navigator.push(
                            //               //         context,
                            //               //         MaterialPageRoute(
                            //               //             // builder: (context) => ChessGame()),
                            //               //             builder: (context) => SplashScrenn()),
                            //               //       );
                            //               //     },
                            //               //     child: Container(
                            //               //       margin: const EdgeInsets.all(10),
                            //               //       height: 80,
                            //               //       width: 65,
                            //               //       decoration: const BoxDecoration(
                            //               //         image: DecorationImage(
                            //               //           image: AssetImage(
                            //               //               "assets/games/Covi KIll.png"),
                            //               //           fit: BoxFit.fill,
                            //               //         ),
                            //               //       ),
                            //               //     ),
                            //               //   ),
                            //               // ),
                            //
                            //               ShakeAnimatedWidget(
                            //                 enabled: true,
                            //                 duration:
                            //                     Duration(milliseconds: 450),
                            //                 shakeAngle: Rotation.deg(z: 4),
                            //                 curve: Curves.linear,
                            //                 child: InkWell(
                            //                   onTap: () {
                            //                     HapticFeedback.vibrate();
                            //                     _otpSent
                            //                         ? showSnackBar(
                            //                             "Please Click on Continue !")
                            //                         : showSnackBar(
                            //                             "Please Click on the Enter The Zone !");
                            //                     // showSnackBar(
                            //                     //     "Please Click on the Enter The Zone !");
                            //                   },
                            //                   child: Container(
                            //                     margin:
                            //                         const EdgeInsets.all(10),
                            //                     height: 80,
                            //                     width: 65,
                            //                     decoration: const BoxDecoration(
                            //                       image: DecorationImage(
                            //                         image: AssetImage(
                            //                             "assets/games/Fun Facts.png"),
                            //                         fit: BoxFit.fill,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //
                            //               ShakeAnimatedWidget(
                            //                 enabled: true,
                            //                 duration:
                            //                     Duration(milliseconds: 450),
                            //                 shakeAngle: Rotation.deg(z: 4),
                            //                 curve: Curves.linear,
                            //                 child: InkWell(
                            //                   onTap: () {
                            //                     HapticFeedback.vibrate();
                            //                     _otpSent
                            //                         ? showSnackBar(
                            //                             "Please Click on Continue !")
                            //                         : showSnackBar(
                            //                             "Please Click on the Enter The Zone !");
                            //
                            //                     // Navigator.push(
                            //                     //   context,
                            //                     //   MaterialPageRoute(
                            //                     //       // builder: (context) => ChessGame()),
                            //                     //       builder: (context) =>
                            //                     //           const Quiz_Screen()),
                            //                     //);
                            //                   },
                            //                   child: Container(
                            //                     margin:
                            //                         const EdgeInsets.all(10),
                            //                     height: 80,
                            //                     width: 65,
                            //                     decoration: const BoxDecoration(
                            //                       image: DecorationImage(
                            //                         image: AssetImage(
                            //                             "assets/games/Quiz Time.png"),
                            //                         fit: BoxFit.fill,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //
                            //               const SizedBox(
                            //                 width: 40,
                            //               ),
                            //             ],
                            //           ),
                            //
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //         ],
                            //       )
                            //     ],
                            //   ),
                           : Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
// height: 70,
// width: 160,
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
// height: 50,
// width: 100,
                                        padding: const EdgeInsets.fromLTRB(
                                            80, 20, 80, 20),
// padding: const EdgeInsets.fromLTRB(
//     60, 15, 60, 15),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/site-logo.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        child: null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: Text(
                                  "SUD Life Experience Zone",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: defaultFontFamily,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
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
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                                              AssetImage(user.icon),size: 25,color: Colors.red,)
                                                : Container(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              user.name,
                                              style:
                                              TextStyle(color: LightColor.appBlue,fontSize: 16),
                                            ),

                                            //Divider(height: 1,thickness: 2,color: Colors.black),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    underline: DropdownButtonHideUnderline(
                                        child: Container()),
                                    onChanged: (newValue) {
                                      newValue = newValue as Item;
                                      if (newValue.name == "Pay Premium") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Pay Premium',
                                                    url_link:
                                                    'https://www.sudlife.in/customer-service/premium-payment-options')));
                                      } else if (newValue.name ==
                                          "Buy Online") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Buy Online',
                                                    url_link:
                                                    'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')));
                                      } else if (newValue.name ==
                                          "Insurance Plan") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Insurance Plans',
                                                    url_link:
                                                    'https://www.sudlife.in/products/life-insurance')));
                                      } else if (newValue.name ==
                                          "Calculate Premium") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Calculate Premiums',
                                                    url_link:
                                                    'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')));
                                      } else if (newValue.name == "Claims") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Claims',
                                                    url_link:
                                                    'https://www.sudlife.in/claims')));
                                      } else if (newValue.name ==
                                          "Customer Portal") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Customer Portal',
                                                    url_link:
                                                    'https://www.sudlife.in/contact-us')));
                                      } else {}
                                      setState(() {
                                        // dropdownValue = newValue! as Item;
                                      });
                                    },
                                    // onChanged: (value) {
                                    //   print(value);
                                    //   setState(() {
                                    //     itemValue = value as Item;
                                    //   });
                                    // },
                                  ),
                                  // child: DropdownButton<String>(
                                  //   dropdownColor: Colors.white,
                                  //   iconSize: 24,
                                  //   elevation: 16,
                                  //   isExpanded: true,
                                  //   value: dropdownValue,
                                  //   iconEnabledColor: LightColor.appBlue,
                                  //   hint: Text(
                                  //     'Self-Help',
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  //   icon: const Icon(
                                  //       Icons.keyboard_arrow_down_rounded),
                                  //   borderRadius: BorderRadius.circular(7.0),
                                  //   style: TextStyle(
                                  //       color: LightColor.appBlue,
                                  //       fontWeight: FontWeight.w600),
                                  //   items: items.map<DropdownMenuItem<String>>(
                                  //       (String value) {
                                  //     return DropdownMenuItem<String>(
                                  //       value: value,
                                  //       child: Text(value),
                                  //     );
                                  //   }).toList(),
                                  //   underline: DropdownButtonHideUnderline(
                                  //       child: Container()),
                                  //   onChanged: (String? newValue) {
                                  //     if (newValue == "Pay Premium") {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => WebViewScreen(
                                  //                   key: _scaffoldKey,
                                  //                   title: 'Pay Premium',
                                  //                   url_link:
                                  //                       'https://www.sudlife.in/customer-service/premium-payment-options')));
                                  //     } else if (newValue ==
                                  //         "Insurance Plans") {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => WebViewScreen(
                                  //                   key: _scaffoldKey,
                                  //                   title: 'Insurance Plans',
                                  //                   url_link:
                                  //                       'https://www.sudlife.in/products/life-insurance')));
                                  //     } else if (newValue ==
                                  //         "Calculate Premiums") {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => WebViewScreen(
                                  //                   key: _scaffoldKey,
                                  //                   title: 'Calculate Premiums',
                                  //                   url_link:
                                  //                       'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')));
                                  //     } else if (newValue == "Claims") {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => WebViewScreen(
                                  //                   key: _scaffoldKey,
                                  //                   title: 'Claims',
                                  //                   url_link:
                                  //                       'https://www.sudlife.in/claims')));
                                  //     } else if (newValue ==
                                  //         "Customer Portal") {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => WebViewScreen(
                                  //                   key: _scaffoldKey,
                                  //                   title: 'Customer Portal',
                                  //                   url_link:
                                  //                       'https://www.sudlife.in/contact-us')));
                                  //     } else {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => WebViewScreen(
                                  //                   key: _scaffoldKey,
                                  //                   title: 'Buy Online',
                                  //                   url_link:
                                  //                       'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')));
                                  //     }
                                  //
                                  //     setState(() {
                                  //       dropdownValue = newValue!;
                                  //     });
                                  //   },
                                  // ),
                                ),
                              ),
                              SizedBox(
                                height: 370.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        gameBox(
                                            context,
                                            gameList[index].url,
                                            gameList[index].name,
                                            gameList[index].image_url),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 40, 0),
                                      child: Container(
                                        height: 45,
                                        width: 180,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10.0)),
                                            side: const BorderSide(
                                              width: 2,
                                              color: Color(0xff0F5A93),
                                            ),
                                          ),
                                          child: Text(
                                            FirebaseAuth.instance.currentUser != null
                                                ? "Exit" : "Login",
                                            style: TextStyle(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 30, 0, 30),
                                      child: Text(
                                        "Protecting Families, Enriching Lives",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: defaultFontFamily,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            //image: AssetImage("assets/images/new.png"),
                            //image: AssetImage("assets/images/Exz Tab Bag.png"),
                            image:
                                AssetImage("assets/images/Text Background.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: 70,
                                    // width: 160,
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
                                      // height: 50,
                                      // width: 100,
                                      padding: const EdgeInsets.fromLTRB(
                                          60, 15, 60, 15),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/site-logo.png"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      child: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     // SlideTransition(
                                //     //   position: _offsetAnimation,
                                //     //   child: const Padding(
                                //     //     padding: EdgeInsets.all(8.0),
                                //     //     child: FlutterLogo(size: 150.0),
                                //     //   ),
                                //     // );
                                //
                                //     Navigator.of(context).push(PageRouteBuilder(
                                //         pageBuilder: (context, animation,
                                //             secondaryAnimation) {
                                //           return ZoneHomeScreen();
                                //         },
                                //         transitionDuration:
                                //         const Duration(milliseconds: 500),
                                //         transitionsBuilder: (context, animation,
                                //             secondaryAnimation, child) {
                                //           return FadeTransition(
                                //             opacity: animation,
                                //             child: child,
                                //           );
                                //         }));
                                //
                                //     //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
                                //
                                //     //   Navigator.of(context).push(_createRoute());
                                //
                                //     // Navigator.push(
                                //     //   context,
                                //     //   MaterialPageRoute(
                                //     //       builder: (context) => ZoneScreen()),
                                //     // );
                                //   },
                                //   child: Container(
                                //     margin: const EdgeInsets.all(10),
                                //     // height: height_size - 360,
                                //     // width: width_size - 470,
                                //     height: 70,
                                //     width: 240,
                                //     decoration: BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: const BorderRadius.only(
                                //           topRight: Radius.circular(20.0),
                                //           bottomRight: Radius.circular(20.0),
                                //           topLeft: Radius.circular(20.0),
                                //           bottomLeft: Radius.circular(20.0)),
                                //       boxShadow: [
                                //         BoxShadow(
                                //           color: Colors.black.withOpacity(0.4),
                                //           spreadRadius: 10,
                                //           blurRadius: 9,
                                //           offset: const Offset(
                                //               0, 3), // changes position of shadow
                                //         ),
                                //       ],
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         'Enter the zone',
                                //         style: TextStyle(
                                //             fontSize: 20,
                                //             fontFamily: defaultFontFamily,
                                //             fontWeight: FontWeight.bold,
                                //             color: Colors.blueAccent.shade400),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                400,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                430,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                //image: AssetImage("assets/images/new.png"),
                                                //image: AssetImage("assets/images/Exz Tab Bag.png"),
                                                image: AssetImage(
                                                    "assets/images/shutterstock_18.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                width: 40,
                                              ),

                                              // ShakeAnimatedWidget(
                                              //   enabled: true,
                                              //   duration: const Duration(milliseconds: 450),
                                              //   shakeAngle: Rotation.deg(z: 4),
                                              //   curve: Curves.linear,
                                              //   child: InkWell(
                                              //     onTap: () {
                                              //       Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: (context) => const ChessGame()),
                                              //       );
                                              //     },
                                              //     child: Container(
                                              //       margin: const EdgeInsets.all(10),
                                              //       // height: height_size - 320,
                                              //       // width: width_size - 665,
                                              //
                                              //       height: 120,
                                              //       width: 100,
                                              //       decoration: const BoxDecoration(
                                              //         image: DecorationImage(
                                              //           image: AssetImage("assets/games/Chesss.png"),
                                              //           fit: BoxFit.fill,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              // ShakeAnimatedWidget(
                                              //   enabled: true,
                                              //   duration: Duration(milliseconds: 450),
                                              //   shakeAngle: Rotation.deg(z: 4),
                                              //   curve: Curves.linear,
                                              //   child: InkWell(
                                              //     onTap: () {
                                              //       Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             // builder: (context) => ChessGame()),
                                              //             builder: (context) => SplashScrenn()),
                                              //       );
                                              //     },
                                              //     child: Container(
                                              //       margin: const EdgeInsets.all(10),
                                              //       height: 100,
                                              //       width: 80,
                                              //       decoration: const BoxDecoration(
                                              //         image: DecorationImage(
                                              //           image: AssetImage(
                                              //               "assets/games/Covi KIll.png"),
                                              //           fit: BoxFit.fill,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              ShakeAnimatedWidget(
                                                enabled: true,
                                                duration:
                                                    Duration(milliseconds: 450),
                                                shakeAngle: Rotation.deg(z: 4),
                                                curve: Curves.linear,
                                                child: InkWell(
                                                  onTap: () {
                                                    HapticFeedback.vibrate();
                                                    _otpSent
                                                        ? showSnackBar(
                                                            "Please Click on Continue !")
                                                        : showSnackBar(
                                                            "Please Click on the Enter The Zone !");
                                                    //showSnackBar("Please Enter The Details to Play !");
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       // builder: (context) => ChessGame()),
                                                    //       builder: (context) =>
                                                    //           const FunFacts_Screen()),
                                                    //);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: 100,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/games/Fun Facts.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ShakeAnimatedWidget(
                                                enabled: true,
                                                duration:
                                                    Duration(milliseconds: 450),
                                                shakeAngle: Rotation.deg(z: 4),
                                                curve: Curves.linear,
                                                child: InkWell(
                                                  onTap: () {
                                                    HapticFeedback.vibrate();
                                                    _otpSent
                                                        ? showSnackBar(
                                                            "Please Click on Continue !")
                                                        : showSnackBar(
                                                            "Please Click on the Enter The Zone !");
                                                    //showSnackBar("Please Enter The Details to Play ! ");
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       // builder: (context) => ChessGame()),
                                                    //       builder: (context) =>
                                                    //           const Quiz_Screen()),
                                                    // );
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: 100,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/games/Quiz Time.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 40,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          !_otpSent
                                              ? Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      80, 0, 80, 40),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 400,
                                                        // width: MediaQuery.of(context)
                                                        //         .size
                                                        //         .width -
                                                        //     1200,
                                                        // height: MediaQuery.of(context)
                                                        //         .size
                                                        //         .height -
                                                        //     500,

                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white, // Set border color
                                                              width: 0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                00, 10, 00, 10),
                                                        child: Column(
                                                          children: [
                                                            // const SizedBox(
                                                            //   height: 40,
                                                            // ),
                                                            FadeAnimation(
                                                                1.1,
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          40,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "Please Enter Your Details To Proceed",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            //fontFamily: defaultFontFamily,
                                                                            color: Colors.redAccent,
                                                                            //Color.fromRGBO(113, 56, 208, 1.0),
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                            // const SizedBox(
                                                            //   height: 40,
                                                            // ),
                                                            FadeAnimation(
                                                                1.1,
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          40,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Enter Your Details",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontFamily: defaultFontFamily,
                                                                            color: LightColor.appBlue,
                                                                            //Color.fromRGBO(113, 56, 208, 1.0),
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 22),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                            // const SizedBox(
                                                            //   height: 40,
                                                            // ),
                                                            FadeAnimation(
                                                                1.1,
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          40,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Name",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontFamily: defaultFontFamily,
                                                                            color: LightColor.appBlue,
                                                                            //Color.fromRGBO(113, 56, 208, 1.0),
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 15),
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
                                                                // width: MediaQuery.of(context)
                                                                //     .size
                                                                //     .width -
                                                                //     180,
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        40,
                                                                        0,
                                                                        40,
                                                                        0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border
                                                                      .all(
                                                                          color: (Colors.grey[
                                                                              800])!, // Set border color
                                                                          width:
                                                                              0.2),
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
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          19,
                                                                      offset: const Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                                child:
                                                                    TextField(
                                                                  minLines: 1,
                                                                  maxLength: 30,
                                                                  controller:
                                                                      _nameController,
                                                                  // inputFormatters: <
                                                                  //     TextInputFormatter>[
                                                                  //   FilteringTextInputFormatter
                                                                  //       .allow(RegExp(
                                                                  //           "[a-z A-Z]")),
                                                                  // ],
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        defaultFontFamily,
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
                                                                      hintText: "  Enter Your Full Name",
                                                                      //filled: false,
                                                                      // fillColor: LightColor.yboxbackpurple,
                                                                      hintStyle: TextStyle(
                                                                          fontSize: 14,
                                                                          // fontFamily:
                                                                          // defaultFontFamily,
                                                                          color: Colors.grey)),
                                                                ),
                                                              ),
                                                            ),
                                                            // const SizedBox(
                                                            //   height: 30,
                                                            // ),
                                                            FadeAnimation(
                                                                1.1,
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          30,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Mobile Number",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                defaultFontFamily,
                                                                            color:
                                                                                LightColor.appBlue,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 15),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                            // const SizedBox(
                                                            //   height: 10,
                                                            // ),
                                                            FadeAnimation(
                                                              0.5,
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  height: 53,
                                                                  // width: MediaQuery.of(context)
                                                                  //     .size
                                                                  //     .width -
                                                                  //     180,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          0,
                                                                          40,
                                                                          0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
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
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                        spreadRadius:
                                                                            1,
                                                                        blurRadius:
                                                                            19,
                                                                        offset: const Offset(
                                                                            0,
                                                                            3), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    inputFormatters: <
                                                                        TextInputFormatter>[
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly
                                                                    ],
                                                                    minLines: 1,
                                                                    maxLength:
                                                                        10,
                                                                    controller:
                                                                        _phoneController,
                                                                    textAlignVertical:
                                                                        TextAlignVertical
                                                                            .center,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontFamily:
                                                                          defaultFontFamily,
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
                                                                            fontSize: 14,
                                                                            // fontFamily:
                                                                            // defaultFontFamily,
                                                                            color: Colors.grey)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      0,
                                                                      20,
                                                                      0,
                                                                      10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            30,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        unselectedWidgetColor:
                                                                            Colors.grey,
                                                                      ),
                                                                      child:
                                                                          Checkbox(
                                                                        checkColor:
                                                                            Colors.blueAccent,
                                                                        activeColor:
                                                                            Colors.white,
                                                                        value:
                                                                            _policyChecked,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(() =>
                                                                              _policyChecked = value!);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: FadeAnimation(
                                                                        1.1,
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              40,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxLines:
                                                                                8,
                                                                            style: TextStyle(
                                                                                fontFamily: defaultFontFamily,
                                                                                color: LightColor.appBlue,
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
                                                                // if (_nameController
                                                                //     .text ==
                                                                //     "") {
                                                                //   showSnackBar(
                                                                //       "Enter Name");
                                                                // } else if (_phoneController
                                                                //     .text ==
                                                                //     "") {
                                                                //   showSnackBar(
                                                                //       "Enter Phone Number");
                                                                // }

                                                                if (_nameController
                                                                        .text ==
                                                                    "") {
                                                                  showSnackBar(
                                                                      "Please Enter Name");
                                                                } else if (_phoneController
                                                                        .text ==
                                                                    "") {
                                                                  showSnackBar(
                                                                      "Please Enter Phone Number");
                                                                } else if (!_policyChecked) {
                                                                  showSnackBar(
                                                                      "Please Accept the policy ");
                                                                } else if (int.tryParse(
                                                                        _phoneController
                                                                            .text) ==
                                                                    null) {
                                                                  showSnackBar(
                                                                      "Only Numbers are allowed");
                                                                } else {
                                                                  _submitPhoneNumber();
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                          .fromLTRB(
                                                                      40,
                                                                      10,
                                                                      40,
                                                                      20),

                                                                  // height: height_size - 360,
                                                                  // width: width_size - 470,
                                                                  height: 50,
                                                                  //width: 260,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: LightColor
                                                                        .appBlue,
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                20.0),
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                20.0),
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                20.0),
                                                                        bottomLeft:
                                                                            Radius.circular(20.0)),
                                                                    // boxShadow: [
                                                                    //   BoxShadow(
                                                                    //     color:
                                                                    //     Colors.black.withOpacity(0.4),
                                                                    //     spreadRadius: 10,
                                                                    //     blurRadius: 9,
                                                                    //     offset: const Offset(0,
                                                                    //         3), // changes position of shadow
                                                                    //   ),
                                                                    // ],
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Enter the zone',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              defaultFontFamily,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // FadeAnimation(
                                                      //     1.1,
                                                      //     Row(
                                                      //       mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .center,
                                                      //       children: [
                                                      //         Text(
                                                      //           "Protecting Families, Enriching Lives",
                                                      //           textAlign:
                                                      //           TextAlign
                                                      //               .center,
                                                      //           style: TextStyle(
                                                      //             //fontFamily: defaultFontFamily,
                                                      //               color: Colors
                                                      //                   .white,
                                                      //               //Color.fromRGBO(113, 56, 208, 1.0),
                                                      //               fontWeight:
                                                      //               FontWeight
                                                      //                   .bold,
                                                      //               fontSize: 22),
                                                      //         ),
                                                      //       ],
                                                      //     )),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .white, // Set border color
                                                        width: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 10, 40, 10),
                                                  child: Column(
                                                    children: [
                                                      // const SizedBox(
                                                      //   height: 20,
                                                      // ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .arrow_back_ios,
                                                                  color: Colors
                                                                      .grey),
                                                              onPressed: () {
                                                                HapticFeedback
                                                                    .vibrate();

                                                                setState(() {
                                                                  _otpSent =
                                                                      false;
                                                                  //_timer.cancel();
                                                                  _timeout =
                                                                      false;
                                                                  _firstDigitOtp
                                                                      .clear();
                                                                  _secondDigitOtp
                                                                      .clear();
                                                                  _thirdDigitOtp
                                                                      .clear();
                                                                  _fourthDigitOtp
                                                                      .clear();
                                                                  _fifthDigitOtp
                                                                      .clear();
                                                                  _sixthDigitOtp
                                                                      .clear();
                                                                });
                                                              },
                                                            ),
                                                            // Text(
                                                            //   "Back",
                                                            //   textAlign:
                                                            //   TextAlign.left,
                                                            //   style: TextStyle(
                                                            //       fontFamily:
                                                            //       defaultFontFamily,
                                                            //       color: Colors
                                                            //           .blueAccent,
                                                            //       fontWeight:
                                                            //       FontWeight
                                                            //           .normal,
                                                            //       fontSize: 18),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      FadeAnimation(
                                                          1.1,
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(40, 0,
                                                                    0, 0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Mobile Verification",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontFamily: defaultFontFamily,
                                                                      color: Colors.blueAccent,
                                                                      //Color.fromRGBO(113, 56, 208, 1.0),
                                                                      fontWeight: FontWeight.normal,
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
                                                            padding: EdgeInsets
                                                                .fromLTRB(40, 0,
                                                                    0, 0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Enter 06 Digit OTP",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontFamily: defaultFontFamily,
                                                                      color: Colors.blueAccent,
                                                                      //Color.fromRGBO(113, 56, 208, 1.0),
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 12),
                                                                ),
                                                                Spacer(),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          40,
                                                                          0),
                                                                  child: Text(
                                                                    '$_start',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontFamily: defaultFontFamily,
                                                                        color: Colors.blueAccent,
                                                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        fontSize: 12),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      FadeAnimation(
                                                        0.5,
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 35,
                                                            ),
                                                            OtpInput(
                                                                _firstDigitOtp,
                                                                true),
                                                            OtpInput(
                                                                _secondDigitOtp,
                                                                false),
                                                            OtpInput(
                                                                _thirdDigitOtp,
                                                                false),
                                                            OtpInput(
                                                                _fourthDigitOtp,
                                                                false),
                                                            OtpInput(
                                                                _fifthDigitOtp,
                                                                false),
                                                            OtpInput(
                                                                _sixthDigitOtp,
                                                                false),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      FadeAnimation(
                                                          1.1,
                                                          InkWell(
                                                            onTap: () {
                                                              if (_timeout) {
                                                                setState(() {
                                                                  _timeout =
                                                                      false;
                                                                  //  _timer.cancel();
                                                                });
                                                                HapticFeedback
                                                                    .vibrate();
                                                                // startTimer();
                                                                _resubmitPhoneNumber();
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    _timeout
                                                                        ? "Resend Otp"
                                                                        : '',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            defaultFontFamily,
                                                                        color: Colors
                                                                            .blueAccent,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _submitOTP(
                                                              verification_id);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  50,
                                                                  10,
                                                                  50,
                                                                  20),

                                                          // height: height_size - 360,
                                                          // width: width_size - 470,
                                                          height: 50,
                                                          //width: 260,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .blueAccent,
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20.0)),
                                                            // boxShadow: [
                                                            //   BoxShadow(
                                                            //     color:
                                                            //     Colors.black.withOpacity(0.4),
                                                            //     spreadRadius: 10,
                                                            //     blurRadius: 9,
                                                            //     offset: const Offset(0,
                                                            //         3), // changes position of shadow
                                                            //   ),
                                                            // ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Continue',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      defaultFontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
              : Container(
                  color: Colors.redAccent,
                  child: const Center(
                      child: Text(
                    'Rooted Device Detected',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showCupertinoDialog<void>(
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
              onPressed: () {
                //clear();
                //dispose();
                SystemNavigator.pop();
                FirebaseAuth.instance.signOut();
                showSnackBar("Logged out successfully!!");
                Navigator.of(context).pop();
              },
              child:
              const Text('Yes', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
              },
              child:
              const Text('No', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
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
      child: Card(
          child: Container(
            width: 300,
            height: 300,
            color: Colors.white,
            child: Image.asset(imageUrl, fit: BoxFit.fill),
            alignment: Alignment.center,
          )),
    );
  }

  void redirectToGame(String name, String url) {
    Navigator.of(context).pop();
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return GameWebViewScreen(
              key: _scaffoldKey, title: name, url_link: url);
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }));
  }

  Object loginView(context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        _femaleChecked = false;
        _maleChecked = true;

        _continuePressed = false;
        _otpDone = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              children: [
                !_otpSent
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
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  "Enter Your Details",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: defaultFontFamily,
                                      color: Colors.blueAccent,
                                      //Color.fromRGBO(113, 56, 208, 1.0),
                                      fontWeight: FontWeight.normal,
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
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 0, 0),
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
                                      fontSize: 15),
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
                                color: (Colors
                                    .grey[800])!, // Set border color
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
                                hintText: "  Enter Your Full Name",
                                filled: false,
                                // fillColor: LightColor.yboxbackpurple,
                                hintStyle: TextStyle(
                                    fontSize: 14,
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
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                      fontFamily: defaultFontFamily,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15),
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
                                color: (Colors
                                    .grey[800])!, // Set border color
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
                                hintText:
                                "  Enter 10 Digit Mobile Number",
                                filled: false,
                                // fillColor: LightColor.yboxbackpurple,
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    // fontFamily:
                                    // defaultFontFamily,
                                    color: Colors.grey)),
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 0,
                      // ),
                      //
                      // FadeAnimation(
                      //     1.1,
                      //     Padding(
                      //       padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             "Gender",
                      //             style: TextStyle(
                      //                 fontFamily: defaultFontFamily,
                      //                 color: Colors.blueAccent,
                      //                 fontWeight: FontWeight.normal,
                      //                 fontSize: 15),
                      //           ),
                      //         ],
                      //       ),
                      //     )),
                      //
                      // const SizedBox(
                      //   height: 0,
                      // ),

                      const SizedBox(
                        height: 20,
                      ),

                      FadeAnimation(
                          1.1,
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender",
                                  style: TextStyle(
                                      fontFamily: defaultFontFamily,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          )),

                      const SizedBox(
                        height: 10,
                      ),

                      Container(
                        height: 50,
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(30, 0, 60, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.grey,
                                ),
                                child: Checkbox(
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                  value: _maleChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _maleChecked = value!;
                                      _femaleChecked = false;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                "Male",
                                style: TextStyle(color: Colors.black54),
                              ),

                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.grey,
                                ),
                                child: Checkbox(
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                  value: _femaleChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _femaleChecked = value!;
                                      _maleChecked = false;
                                    });
                                  },
                                ),
                              ),
                              Text(
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
                              padding:
                              const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.grey,
                                ),
                                child: Checkbox(
                                  checkColor: Colors.blueAccent,
                                  activeColor: Colors.white,
                                  value: _policyChecked,
                                  onChanged: (value) {
                                    setState(
                                            () => _policyChecked = value!);
                                  },
                                ),
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
                                      maxLines: 5,
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
                          } else if (!_policyChecked) {
                            showSnackBar("Please Accept the policy ");
                          } else if (int.tryParse(
                              _phoneController.text) ==
                              null) {
                            showSnackBar("Only Number are allowed");
                          } else {
                            showSnackBar("Processing...");
                            _submitPhoneNumber();
                          }
                        },
                        child: Container(
                          margin:
                          const EdgeInsets.fromLTRB(40, 10, 40, 20),

                          // height: height_size - 360,
                          // width: width_size - 470,
                          height: 50,
                          //width: 260,
                          decoration: BoxDecoration(
                            color: LightColor.appBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _continuePressed ? SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator( color: Colors.white),
                            ) : Text(
                              'Enter the zone',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: defaultFontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            // child: Text(
                            //   'Enter the zone',
                            //   style: TextStyle(
                            //       fontSize: 16,
                            //       fontFamily: defaultFontFamily,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white),
                            // ),
                          ),
                        ),
                      ),
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
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.grey),
                              onPressed: () {
                                HapticFeedback.vibrate();

                                setState(() {
                                  _otpSent = false;
                                  //_timer.cancel();
                                  _timeout = false;
                                  _firstDigitOtp.clear();
                                  _secondDigitOtp.clear();
                                  _thirdDigitOtp.clear();
                                  _fourthDigitOtp.clear();
                                  _fifthDigitOtp.clear();
                                  _sixthDigitOtp.clear();
                                });
                              },
                            ),
                            // Text(
                            //   "Back",
                            //   textAlign:
                            //   TextAlign.left,
                            //   style: TextStyle(
                            //       fontFamily:
                            //       defaultFontFamily,
                            //       color: Colors
                            //           .blueAccent,
                            //       fontWeight:
                            //       FontWeight
                            //           .normal,
                            //       fontSize: 18),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FadeAnimation(
                          1.1,
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Row(
                              children: [
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
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.1,
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter 06 Digit OTP",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: defaultFontFamily,
                                      color: Colors.blueAccent,
                                      //Color.fromRGBO(113, 56, 208, 1.0),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 40, 0),
                                  child: Text(
                                    "",
                                    // _start.toString() ==
                                    //         "0"
                                    //     ? ''
                                    //     : '$_start',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: defaultFontFamily,
                                        color: Colors.blueAccent,
                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        0.5,
                        Row(
                          children: [
                            const SizedBox(
                              width: 35,
                            ),
                            OtpInput(_firstDigitOtp, true),
                            OtpInput(_secondDigitOtp, false),
                            OtpInput(_thirdDigitOtp, false),
                            OtpInput(_fourthDigitOtp, false),
                            OtpInput(_fifthDigitOtp, false),
                            OtpInput(_sixthDigitOtp, false),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.1,
                          InkWell(
                            onTap: () {
                              if (_timeout) {
                                HapticFeedback.vibrate();
                                setState(() {
                                  _timeout = false;
                                  //_timer.cancel();
                                });
                                _resubmitPhoneNumber();

                                //startTimer();

                              } else {
                                showSnackBar("OTP already sent");
                              }
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _timeout
                                        ? "Resend Otp"
                                        : "Didn't receive OTP! Resend in 2 minutes",
                                    style: TextStyle(
                                        fontFamily: defaultFontFamily,
                                        color: _timeout
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
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          HapticFeedback.vibrate();
                          _submitOTP(verification_id);

                          //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));

                          //   Navigator.of(context).push(_createRoute());

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ZoneScreen()),
                          // );
                        },
                        child: Container(
                          margin:
                          const EdgeInsets.fromLTRB(50, 10, 50, 20),

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
                            // boxShadow: [
                            //   BoxShadow(
                            //     color:
                            //     Colors.black.withOpacity(0.4),
                            //     spreadRadius: 10,
                            //     blurRadius: 9,
                            //     offset: const Offset(0,
                            //         3), // changes position of shadow
                            //   ),
                            // ],
                          ),
                          child: Center(
                            child: _otpDone ? SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator( color: Colors.white),
                            ) : Text(
                              'Continue',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: defaultFontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          // child: Center(
                          //   child: Text(
                          //     'Continue',
                          //     style: TextStyle(
                          //         fontSize: 16,
                          //         fontFamily: defaultFontFamily,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.white),
                          //   ),
                          // ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
              backgroundColor: Colors.white,
            );
          },
        );
      },
    );
  }

  void redirectToScreen(String name, String url) {
    if (name == "Fun Facts") {
      Navigator.of(context).pop();
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FunFacts_Screen();
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
            return Quiz_Screen();
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
      phoneNumber = "+91 " + _phoneController.text.toString().trim();

      if (kDebugMode) {
        print(defaultTargetPlatform);
      }

      // if (TargetPlatform.android == defaultTargetPlatform ||
      //     TargetPlatform.iOS == defaultTargetPlatform ||
      //     TargetPlatform.macOS == defaultTargetPlatform) {

      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(seconds: 120),
            verificationFailed: (Exception error) {
              if (kDebugMode) {
                print(error);
              }
              setState( () => _continuePressed = false);
              showSnackBar("Something went wrong, please try again.");
              //showSnackBar(error.toString());
            },
            codeSent: (String verificationId, int? resendToken) async {
              showSnackBar("OTP sent!");

              // startTimer();
              setState(() {
                _otpSent = true;
                verification_id = verificationId;
              });
              Navigator.pop(context);
              loginView(context);
            },
            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
              showSnackBar("Verified.");
            },
            codeAutoRetrievalTimeout: (String verificationId) {

              setState(() {
                _continuePressed = false;
                _timeout = true;
              });
              showSnackBar("Timed out!");
            },
          );
          if (kDebugMode) {
            print('connected');
          }
        }
      } on SocketException catch (_) {
        showSnackBar("Your internet connection is not working.");
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
      phoneNumber = "+91 " + _phoneController.text.toString().trim();

      print(defaultTargetPlatform);
      if (TargetPlatform.android == defaultTargetPlatform ||
          TargetPlatform.iOS == defaultTargetPlatform ||
          TargetPlatform.macOS == defaultTargetPlatform) {
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              timeout: const Duration(seconds: 120),
              verificationFailed: (Exception error) {
                print(error);

                showSnackBar("Something went wrong, please try again.");
              },
              codeSent: (String verificationId, int? resendToken) async {
                showSnackBar("Resent OTP !");

                setState(() {
                  _timeout = false;
                  _otpSent = true;
                  _continuePressed = true;
                  verification_id = verificationId;
                });
                Navigator.pop(context);
                loginView(context);
              },
              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                showSnackBar("Verified.");
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                setState(() {
                  _timeout = true;
                });
                //showSnackBar("Timeout!");
              },
            );
            print('connected');
          }
        } on SocketException catch (_) {
          showSnackBar("Your internet connection is not working.");
        }
      }
    }
  }

  Future<void> _submitOTP(verificationId) async {
    String smsCode;
    print(defaultTargetPlatform);

    if (_firstDigitOtp.text.trim() == '') {
      showSnackBar("Enter First Digit Of OTP");
    } else if (_secondDigitOtp.text.trim() == "") {
      showSnackBar("Enter Second Digit Of OTP");
    } else if (_thirdDigitOtp.text.trim() == "") {
      showSnackBar("Enter Third Digit Of OTP");
    } else if (_fourthDigitOtp.text.trim() == "") {
      showSnackBar("Enter Fourth Digit Of OTP");
    } else if (_fifthDigitOtp.text.trim() == "") {
      showSnackBar("Enter Fifth Digit Of OTP");
    } else if (_sixthDigitOtp.text.trim() == "") {
      showSnackBar("Enter Sixth Digit Of OTP");
    } else {

      setState(() {
        _otpDone = true;
      });

      showProgressSnackBar("Logging you in");
      smsCode = _firstDigitOtp.text +
          _secondDigitOtp.text +
          _thirdDigitOtp.text +
          _fourthDigitOtp.text +
          _fifthDigitOtp.text +
          _sixthDigitOtp.text;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verification_id, smsCode: smsCode);

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((UserCredential authRes) {
        if (authRes.user != null) {

          setState(() {
            _otpDone = false;
            _continuePressed = false;
          });

          String? id = authRes.user?.uid;
          String? name = _nameController.text.toString();

          Map<String, String> _userMap = {
            'Name': _nameController.text.toString(),
            'Number': _phoneController.text.toString(),
          };

          FirebaseDatabase.instance
              .reference()
              .child('SUDCustomer/Customers/' +
                  name +
                  "-" +
                  id.toString() +
                  "/" +
                  DateTime.now().millisecondsSinceEpoch.toString())
              .set(_userMap)
              .then(
                (value) => setState(() {}),
              );

          print("Verified");
          // print(authRes.user);
          Navigator.of(context).pop();
          showSnackBar("Logged in successfully !!");

          // Navigator.of(context).push(PageRouteBuilder(
          //     pageBuilder: (context, animation, secondaryAnimation) {
          //       return ZoneHomeScreen();
          //     },
          //     transitionDuration: const Duration(milliseconds: 500),
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) {
          //       return FadeTransition(
          //         opacity: animation,
          //         child: child,
          //       );
          //     }));
        } else {
          setState(() {
            _otpDone = false;
            _continuePressed = false;
          });

          showSnackBar("Enter Correct OTP");
        }
      }).catchError((e) => {
                showSnackBar("Enter Correct OTP"),
                print(e),
              });
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
      print("Banner Timer Canceled in Dispose() ");
    } else {
      print("Banner Timer Not Canceled in Dispose() ");
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
      content: Container(
        height: 30,
        child: Row(
          children: [
            Text(
              "Logging you in",
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
    final snackBar = SnackBar(
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
    });

    // flush = Flushbar<bool>(
    //   duration: Duration(seconds: 2),
    //   isDismissible: true,
    //   title: " ",
    //   //message: "Enter correct number!",
    //   message: error.toString(),
    //   showProgressIndicator: false,
    //   backgroundGradient: LinearGradient(
    //     colors: [LightColor.ypurple, Colors.white],
    //     stops: [0.6, 1],
    //   ),
    //   margin: EdgeInsets.all(20),
    //   icon: Icon(
    //     Icons.warning_rounded,
    //     color: Colors.white,
    //   ),
    // )
    //   ..show(context).then((result) {
    //   });
    // flush.duration;
    // HapticFeedback.vibrate();
  }

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
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
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
        style: TextStyle(
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
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
