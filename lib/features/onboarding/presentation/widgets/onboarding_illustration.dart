import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SvgPicture.asset(
        height: 150,
        "assets/img/onboarding_illus.svg",
        fit: BoxFit.contain,
      ),
    );
  }
}
