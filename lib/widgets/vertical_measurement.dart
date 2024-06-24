import 'package:draw_dxf_test/utils/app_extension.dart';
import 'package:flutter/material.dart';

class VerticalMeasurement extends StatelessWidget {
  const VerticalMeasurement(
      {super.key,
      required this.height,
      required this.isLeftSide,
      required this.width});
  final double height;
  final double width;
  final bool isLeftSide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 50,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              right: isLeftSide ? 0 : null,
              left: isLeftSide ? null : 0,
              child: const VerticalDivider()),
          Positioned(
            top: height / 2 - 10,
            right: isLeftSide ? 0 : null,
            left: isLeftSide ? null : 0,
            child: Text("${height.toStringAsInches} ",
                style: const TextStyle(backgroundColor: Colors.white)),
          )
        ],
      ),
    );
  }
}
