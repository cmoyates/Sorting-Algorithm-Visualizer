import 'package:flutter/material.dart';

class SortingBar extends StatelessWidget {

  final double containingWidth;
  final double containingHeight;
  final Color color;
  final int totalBarNum;
  final double val;

  SortingBar({this.containingWidth, this.containingHeight, this.color, this.totalBarNum, this.val});

  double GetVal () {
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.6) / (totalBarNum * 1.25),
      height: (MediaQuery.of(context).size.height * val * 0.8),
      color: color,
    );
  }
}
