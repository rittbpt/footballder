import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget(
      {Key? key, required this.onPressed, required this.icon,this.borderColor = const Color(0xFFD94A38),})
      : super(key: key);
  final VoidCallback onPressed;
  final Icon icon;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    double buttonSize = 60.0;
    return Material(
      shape: const CircleBorder(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
          side: BorderSide(color: borderColor, width: 2.0), // Add border side
        ),
        color: Colors.white, // Set the card color to white
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
          ),
        ),
      ),
    );
  }
}