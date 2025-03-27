// change_password_page.dart
import 'package:dirassati/features/profile/presentation/widgets/password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await SystemChannels.textInput.invokeMethod('TextInput.hide');
              await Future.delayed(const Duration(milliseconds: 100));
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Changer mot de passe",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.left,
          ),
          titleSpacing: -5.0,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: PasswordFormWidget(),
        ),
      ),
    );
  }
}
