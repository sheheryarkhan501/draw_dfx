import 'package:draw_dxf_test/utils/app_extension.dart';
import 'package:flutter/material.dart';

class HorizontalMeasurement extends StatelessWidget {
  final double width;
  final double height;
  final void Function(double) onWidthChanged;
  HorizontalMeasurement(
      {super.key,
      required this.width,
      required this.height,
      required this.onWidthChanged});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = width.toInches.toStringAsFixed(1);
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          const Divider(),
          Positioned(
            top: 0,
            left: width / 2 - 15,
            child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  labelText: "Enter width in inches"),
                              onSubmitted: (value) {
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    double? value =
                                        double.tryParse(controller.text);
                                    if (value != null) {
                                      onWidthChanged(value.toPixels);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Update"))
                            ],
                          ));
                },
                child: Text("${width.toStringAsInches}",
                    style: const TextStyle(backgroundColor: Colors.white))),
          )
        ],
      ),
    );
  }
}
