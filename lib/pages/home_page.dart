import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:draw_dxf_test/utils/app_extension.dart';
import 'package:draw_dxf_test/models/shape_model.dart';
import 'package:draw_dxf_test/widgets/horizontal_measurement.dart';
import 'package:draw_dxf_test/widgets/menu_option.dart';
import 'package:draw_dxf_test/widgets/shape.dart';
import 'package:draw_dxf_test/widgets/vertical_measurement.dart';
import 'package:dxf/dxf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 0 for Kitchen Counter top and 1 for Island
  int selectedMenu = 0;

  /// width of the vertical measurement widget
  double verticalMeasurementWidth = 50;

  /// height of the horizontal measurement widget
  double horizontalMeasurementHeight = 20;

  /// height of the app bar
  double appBarHeight = 80;

  /// minimum width of the shape
  double minimumShapeWidth = 5;

  /// when user drag new shape created and store data in it and when user stop dragging it will add to shapes list
  ShapeModel? newShape;

  /// list of all shapes
  List<ShapeModel> shapes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: appBarHeight,
            color: const Color.fromARGB(255, 208, 234, 208),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  MenuOption(
                      text: 'Kitchen Counter top',
                      isSelected: selectedMenu == 0,
                      onTap: () {
                        setState(() {
                          selectedMenu = 0;
                        });
                      }),
                  const SizedBox(width: 20),
                  MenuOption(
                      text: 'Island',
                      isSelected: selectedMenu == 1,
                      onTap: () {
                        setState(() {
                          selectedMenu = 1;
                        });
                      }),
                  const Spacer(),
                  const Text('Draw your shape',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  const Spacer(
                    flex: 4,
                  ),
                  MenuOption(
                      text: 'Reset',
                      isSelected: false,
                      onTap: () {
                        setState(() {
                          shapes.clear();
                        });
                      }),
                  const SizedBox(width: 20),
                  MenuOption(
                      text: 'Export',
                      isSelected: false,
                      onTap: () {
                        exportDXF();
                      }),
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                // print(details.globalPosition);
                setState(() {
                  if (newShape == null) {
                    newShape = ShapeModel(
                        top: max(0, details.globalPosition.dy) - appBarHeight,
                        left: max(0, details.globalPosition.dx) -
                            verticalMeasurementWidth,
                        width: minimumShapeWidth,
                        height:
                            selectedMenu == 1 ? 30.0.toPixels : 25.5.toPixels);
                  } else {
                    newShape!.width = max(minimumShapeWidth,
                        details.globalPosition.dx - newShape!.left);
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  shapes.add(newShape!);
                  newShape = null;
                });
              },
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    if (shapes.isEmpty)
                      const Center(
                        child: Text('Hold and drag to create a shape'),
                      ),
                    for (var shapeData in shapes)
                      //  shape(shapeData),
                      Shape(
                          onUpdated: () {
                            setState(() {});
                          },
                          horizontalMeasurementHeight:
                              horizontalMeasurementHeight,
                          verticalMeasurementWidth: verticalMeasurementWidth,
                          shapeData: shapeData,
                          sendToFront: sendToFront,
                          appBarHeight: appBarHeight),
                    if (newShape != null)
                      Shape(
                          onUpdated: () {
                            setState(() {});
                          },
                          shapeData: newShape!,
                          sendToFront: sendToFront,
                          horizontalMeasurementHeight:
                              horizontalMeasurementHeight,
                          verticalMeasurementWidth: verticalMeasurementWidth,
                          appBarHeight: appBarHeight),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendToFront(ShapeModel shapeData) {
    setState(() {
      shapes.remove(shapeData);
      shapes.add(shapeData);
    });
  }

  void exportDXF() {
    final dxf = DXF.create();

    for (var shapeData in shapes) {
      dxf.addEntities(
        AcDbLine(
          x: shapeData.left,
          x1: shapeData.left + shapeData.width,
          y: shapeData.top,
          y1: shapeData.top + 1,
          layerName: shapes.indexOf(shapeData).toString(),
        ),
      );
      dxf.addEntities(
        AcDbLine(
          x: shapeData.left,
          x1: shapeData.left + 1,
          y: shapeData.top,
          y1: shapeData.top + shapeData.height,
          layerName: shapes.indexOf(shapeData).toString(),
        ),
      );
      dxf.addEntities(
        AcDbLine(
          x: shapeData.left + shapeData.width,
          x1: shapeData.left + shapeData.width - 1,
          y: shapeData.top,
          y1: shapeData.top + shapeData.height,
          layerName: shapes.indexOf(shapeData).toString(),
        ),
      );
      dxf.addEntities(
        AcDbLine(
          x: shapeData.left,
          x1: shapeData.left + shapeData.width,
          y: shapeData.top + shapeData.height,
          y1: shapeData.top + shapeData.height - 1,
          layerName: shapes.indexOf(shapeData).toString(),
        ),
      );
    }
    print(dxf.dxfString);
    //check is on web
    if (kIsWeb) {
      final bytes = utf8.encode(dxf.dxfString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'example.dxf')
        ..click();
      html.Url.revokeObjectUrl(url);
      // File('export.dxf').writeAsStringSync(dxf.dxfString);
    } else {}
  }
}
