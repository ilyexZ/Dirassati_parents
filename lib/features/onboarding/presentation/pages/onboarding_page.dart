import 'package:flutter/material.dart';
import 'package:dirassati/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:dirassati/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:dirassati/features/onboarding/presentation/widgets/onboarding_illustration.dart';
import '../widgets/onboarding_instructions.dart';
import '../widgets/onboarding_dots.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<String> instructions = [
    "Avec Dirassati, suivez facilement la scolarité de votre enfant. Consultez sa présence, son comportement, ses notes et bien plus, où que vous soyez.",
    "Profitez d’une interface moderne et facile à utiliser. Tout est clair et agréable à lire, pour un suivi sans prise de tête !",
    "Plus besoin d’attendre les réunions parents-profs pour tout savoir ! Recevez en temps réel les informations essentielles sur la scolarité de votre enfant et échangez facilement avec l’établissement. Commençons !",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(), 
            const OnboardingIllustration(), 

            Expanded(
              flex: 3,
              child: OnboardingInstructions(
                instructions: instructions,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
              ),
            ),

            const SizedBox(height: 10),
            OnboardingDots(
              itemCount: instructions.length,
              currentPage: currentPage,
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: const OnboardingButton(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
