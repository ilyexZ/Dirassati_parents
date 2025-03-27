import 'package:dirassati/features/auth/presentation/widgets/label_text_style.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
     final inputGrey = Color(0xFF8A8A8A);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Adresse Email',
            style: TextStyle(fontSize: 14,)),
        
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon:  Icon(Icons.email_outlined, color: inputGrey),
              labelText: "p.nom@esi-sba.dz",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: labelTextStyle,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  borderSide: BorderSide(color: Colors.grey)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
