import 'package:flutter/material.dart';
import 'package:dirassati/features/auth/presentation/widgets/label_text_style.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mot de passe',
            style: TextStyle(fontSize: 16, fontFamily: "Poppins")),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextField(
            enableSuggestions: false,
            enableInteractiveSelection: true,
            readOnly: false, 
            controller: widget.controller,
            obscureText: isObscured,
            obscuringCharacter: "*",
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              suffixIcon: IconButton(
                icon: Icon(
                    isObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey),
                onPressed: () => setState(() => isObscured = !isObscured),
              ),
              prefixIcon: const Icon(Icons.lock_outlined, color: Colors.grey),
              labelText: "************",
              labelStyle: labelTextStyle,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              // focusedBorder: const OutlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(7)),
              //   borderSide:
              //       BorderSide(color: Colors.blue), // Highlighted when focused
              // ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
