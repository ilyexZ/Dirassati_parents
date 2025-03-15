import 'package:flutter/material.dart';
import 'package:dirassati/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:dirassati/core/services/shared_prefernces_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  // List of instructional texts for each onboarding page.
  final List<String> instructions = [
    "Avec Dirassati, suivez facilement la scolarité de votre enfant. Consultez sa présence, son comportement, ses notes et bien plus, où que vous soyez.",
    "Profitez d’une interface moderne et facile à utiliser. Tout est clair et agréable à lire, pour un suivi sans prise de tête !",
    "Plus besoin d’attendre les réunions parents-profs pour tout savoir ! Recevez en temps réel les informations essentielles sur la scolarité de votre enfant et échangez facilement avec l’établissement. Commençons !",
  ];

  /// Marks onboarding as seen by setting a flag in SharedPreferences.
  Future<void> _markOnboardingSeen() async {
    final prefs = await SharedPreferencesService.getInstance();
    await prefs.setBool("seenOnboarding", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea ensures content avoids notches/system UI.
      body: SafeArea(
        child: Column(
          children: [
            // 1) HEADINGS AT THE TOP
            const SizedBox(height: 100,),
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
            const SizedBox(height: 5),
            Text(
              'Restez proche de vos enfants',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // 2) ILLUSTRATION IN THE MIDDLE
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                height: 150,
                "assets/img/onboarding_illus.svg",
                fit: BoxFit.contain,
              ),
            ),

            // 3) PAGEVIEW FOR INSTRUCTIONS
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: instructions.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
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
              ),
            ),

            // 4) DOT INDICATORS + BOTTOM BUTTON
            const SizedBox(height: 10),
            // DOT INDICATORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                instructions.length,
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
            ),
            const SizedBox(height: 20),

            // BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  
                    // On the last page, mark onboarding as seen and navigate.
                    await _markOnboardingSeen();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthWrapper()),
                    );
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D44B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                      child: Text(
                        "Commencer",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0,0,10,0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
