import 'package:flutter/material.dart';

class CloudWidget extends StatelessWidget {
  final double x;
  final double y;

  const CloudWidget({
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
        'assets/cloud.png',
        width: 200, // Фиксированная ширина
        height: 200, // Фиксированная высота
      ),
    );
  }
}
