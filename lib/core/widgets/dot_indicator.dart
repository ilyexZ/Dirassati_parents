import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;
  
  const DotIndicator({super.key, required this.isActive});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
