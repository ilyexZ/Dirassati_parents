import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4D44B5)),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
        child: Text("Se connecter", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
