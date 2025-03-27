import 'package:flutter/material.dart';

class OnboardingInstructions extends StatelessWidget {
  final List<String> instructions;
  final PageController controller;
  final Function(int) onPageChanged;

  const OnboardingInstructions({
    super.key,
    required this.instructions,
    required this.controller,
    required this.onPageChanged,
  }) ;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: instructions.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              instructions[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
