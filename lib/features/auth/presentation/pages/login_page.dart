import 'package:dirassati/core/auth_info_provider.dart';
import 'package:dirassati/core/services/notification_service.dart';
import 'package:dirassati/features/acceuil/domain/providers/students_provider.dart';
import 'package:dirassati/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/widgets/background_shapes.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/forgot_password.dart';
import '../widgets/login_button.dart';
import '../../domain/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Persist controllers in the State so they are not recreated on every build.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authStateProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BackgroundShapes(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Authentifiez à vorte compte",
                    style: TextStyle(color: Color(0xFF393939)),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  
                  EmailField(controller: emailController),
                  const SizedBox(height: 20),
                  PasswordField(controller: passwordController),
                  const SizedBox(height: 5),
                  const ForgotPassword(),
                  const SizedBox(height: 40),
                  LoginButton(
                    onPressed: () async {
                      try {
                        FocusScope.of(context).unfocus();
                        await authNotifier.login(
                          emailController.text,
                          passwordController.text,
                        );
                        // Invalidate providers to fetch fresh data
                        ref.invalidate(authInfoProvider);
                        ref.invalidate(parentIdProvider);
                        ref.invalidate(profileProvider);
                        ref.invalidate(studentsProvider);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            content:
                                const Text("Login failed: Invalid credentials"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                   
                  ),
                  // Debug Login Button for testing:
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          FocusScope.of(context).unfocus();
                          await authNotifier.debugLogin();
                          // Invalidate providers to fetch fresh data
                          ref.invalidate(authInfoProvider);
                          ref.invalidate(parentIdProvider);
                          ref.invalidate(profileProvider);
                          ref.invalidate(studentsProvider);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login failed: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text("Debug Login")),
                  ElevatedButton(
                    onPressed: () {
                      showStaticNotification();
                    },
                    child: const Text("Show Notification"),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
