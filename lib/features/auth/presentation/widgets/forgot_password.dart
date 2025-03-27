import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => debugPrint("forgotPassword UseCase!"),
        child: const Text(
          "Mot de passe oublié?",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,letterSpacing: 0.3),
        ),
      ),
    );
  }
}
