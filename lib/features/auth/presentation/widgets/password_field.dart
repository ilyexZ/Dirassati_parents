import 'package:flutter/material.dart';
import 'package:dirassati/features/auth/presentation/widgets/label_text_style.dart';
import 'package:flutter_svg/svg.dart';

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
    final inputGrey = Color(0xFF8A8A8A);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mot de passe',
            style: TextStyle(
              fontSize: 14,
            )),
        SizedBox(
          height: 45,
          child: TextField(
            autofillHints: const [AutofillHints.password],
            controller: widget.controller,
            
            enableSuggestions: false,
            enableInteractiveSelection: true,
            obscureText: isObscured,
            obscuringCharacter: "*",
            readOnly: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              suffixIcon: IconButton(
                icon: Icon(
                    isObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: inputGrey),
                onPressed: () => setState(() => isObscured = !isObscured),
              ),
              prefixIcon: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/img/lockdotted.svg",
                  width: 20,
                  fit: BoxFit.contain,
                  color: inputGrey,
                ),
              ),

              labelText: "************",
              labelStyle: labelTextStyle,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: inputGrey),
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
