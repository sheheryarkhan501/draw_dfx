import 'dart:math';

import 'package:draw_dxf_test/models/shape_model.dart';
import 'package:draw_dxf_test/widgets/horizontal_measurement.dart';
import 'package:draw_dxf_test/widgets/vertical_measurement.dart';
import 'package:flutter/material.dart';

class Shape extends StatelessWidget {
  void Function() onUpdated;
  void Function(ShapeModel shape) sendToFront;
  final ShapeModel shapeData;
  final double appBarHeight;
  final double horizontalMeasurementHeight;
  final double verticalMeasurementWidth;

  Shape(
      {super.key,
      required this.onUpdated,
      required this.shapeData,
      required this.sendToFront,
      required this.appBarHeight,
      required this.horizontalMeasurementHeight,
      required this.verticalMeasurementWidth});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: shapeData.top - horizontalMeasurementHeight,
      left: shapeData.left - verticalMeasurementWidth,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VerticalMeasurement(
            height: shapeData.height,
            isLeftSide: true,
            width: verticalMeasurementWidth,
          ),
          Column(
            children: [
              HorizontalMeasurement(
                onWidthChanged: (width) {
                  shapeData.width = width;
                  onUpdated();
                },
                width: shapeData.width,
                height: horizontalMeasurementHeight,
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  // print(details.globalPosition);
                  double top = max(0, details.globalPosition.dy) -
                      (shapeData.height / 2) +
                      -appBarHeight;
                  double left =
                      max(0, details.globalPosition.dx) - (shapeData.width / 2);

                  shapeData.top = top;
                  shapeData.left = left;
                  onUpdated();
                },
                onPanEnd: (details) {
                  sendToFront(shapeData);
                },
                child: Container(
                  width: shapeData.width,
                  height: shapeData.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  // color: Colors.blue,
                ),
              ),
              HorizontalMeasurement(
                  onWidthChanged: (width) {
                    shapeData.width = width;
                    onUpdated();
                  },
                  width: shapeData.width,
                  height: horizontalMeasurementHeight),
            ],
          ),
          GestureDetector(
            onPanUpdate: (details) {
              double width =
                  max(20, details.globalPosition.dx - shapeData.left);
              shapeData.width = width;

              onUpdated();
            },
            onPanEnd: (details) {
              sendToFront(shapeData);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeRight,
              child: Container(
                height: shapeData.height,
                width: 5,
                // color: Colors.red,
              ),
            ),
          ),
          VerticalMeasurement(
            height: shapeData.height,
            isLeftSide: false,
            width: verticalMeasurementWidth,
          ),
        ],
      ),
    );
  }
}
