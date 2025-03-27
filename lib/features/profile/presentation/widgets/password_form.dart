// lib/features/auth/presentation/widgets/password_form.dart
import 'package:dirassati/features/auth/presentation/widgets/label_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'inline_error_box.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class PasswordFormWidget extends ConsumerStatefulWidget {
  const PasswordFormWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<PasswordFormWidget> createState() => _PasswordFormWidgetState();
}

class _PasswordFormWidgetState extends ConsumerState<PasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _showErrorBox = false;
  String _errorMessage = "";
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _showErrorBox = false;
      });
      final changePasswordUseCase = ref.read(changePasswordUseCaseProvider);
      try {
        await changePasswordUseCase.execute(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
        setState(() {
          _isLoading = false;
        });
        // Show success notification or navigate as needed.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password changed successfully!"),
        ));
      } catch (e) {
        setState(() {
          _isLoading = false;
          _showErrorBox = true;
          _errorMessage = "Échec: opération échouée, veuillez réessayer.";
        });
      }
    }
  }

  InputDecoration get _inputDecoration => InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        prefixIcon: Icon(
          PhosphorIcons.lockSimple(),
          size: 20,
        ),
        labelText: "Password",
        labelStyle: labelTextStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text("Mot de pass actuel"),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              enableInteractiveSelection: true,
              controller: _currentPasswordController,
              obscureText: false,
              decoration: _inputDecoration,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez entrer votre mot de passe actuel";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text("Nouveau Mot de pass", textAlign: TextAlign.left),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              enableInteractiveSelection: true,
              controller: _newPasswordController,
              obscureText: false,
              decoration: _inputDecoration.copyWith(
                labelText: "New Password",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez entrer un nouveau mot de passe";
                } else if (value.length < 6) {
                  return "Le mot de passe doit comporter au moins 6 caractères";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_showErrorBox)
            InlineErrorBox(
              errorMessage: _errorMessage,
              onClose: () {
                setState(() {
                  _showErrorBox = false;
                });
              },
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B3EE5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      "Continuer",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
