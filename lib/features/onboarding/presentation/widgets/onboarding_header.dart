import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 100),
        Text(
          'Bienvenue dans Dirassati',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.03,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Restez proche de vos enfants',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
