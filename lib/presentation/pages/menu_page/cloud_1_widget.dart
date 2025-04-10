import 'package:flutter/material.dart';

class Cloud_1_Widget extends StatelessWidget {
  final double x;
  final double y;

  const Cloud_1_Widget({
    Key? key,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Image.asset(
        'assets/cloud_1.png',
        width: 150, // Фиксированная ширина
        height: 150, // Фиксированная высота
      ),
    );
  }
}
