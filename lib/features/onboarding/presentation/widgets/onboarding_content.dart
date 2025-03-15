import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String text;
  
  const OnboardingContent({super.key, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
