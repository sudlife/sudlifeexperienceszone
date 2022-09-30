import 'package:flutter/material.dart';

class CrossClipper extends CustomClipper<Path> {
  final bool showTop;
  final double clipHeightRatio;
  late double _higherEnding;
  late double _lowerEnding;

  CrossClipper({this.showTop = true, this.clipHeightRatio = 0.5}) {
    _higherEnding = clipHeightRatio + 0.0;
    _lowerEnding = clipHeightRatio - 0.0;
  }

  @override
  Path getClip(Size size) {
    if (showTop) {
      return clipBottom(size);
    } else {
      return clipTop(size);
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }


  clipTop(Size size) {

    var path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, size.height * _higherEnding);
    path.lineTo(size.width, size.height * _lowerEnding);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  clipBottom(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * _higherEnding);
    path.lineTo(size.width, size.height * _lowerEnding );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }


}
