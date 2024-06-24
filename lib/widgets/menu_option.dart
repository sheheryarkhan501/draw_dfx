import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  const MenuOption(
      {super.key,
      required this.onTap,
      required this.text,
      required this.isSelected});
  final void Function() onTap;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green
              : const Color.fromARGB(255, 211, 238, 212),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 20,
                    color: isSelected ? Colors.white : Colors.black))),
      ),
    );
  }
}
