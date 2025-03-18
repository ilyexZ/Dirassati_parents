import 'package:dirassati/core/services/shared_prefernces_service.dart';
import 'package:flutter/material.dart';
import 'package:dirassati/features/auth/presentation/pages/auth_wrapper.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({super.key});
  Future<void> _markOnboardingSeen() async {
    final prefs = await SharedPreferencesService.getInstance();
    await prefs.setBool("seenOnboarding", true);
  }

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
                onPressed: () async {
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
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              );
  }
}