import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => print("forgotPassword UseCase!"),
        child: const Text(
          "Mot de passe oublié?",
          style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
