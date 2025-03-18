import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const OnboardingDots({
    Key? key,
    required this.itemCount,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 10,
          width: currentPage == index ? 20 : 10,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
