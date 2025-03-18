import 'package:dirassati/features/acceuil/presentation/pages/acceuil_page.dart';
import 'package:dirassati/features/profile/presentation/pages/compte_page.dart';
import 'package:dirassati/core/widgets/navbar.dart';
import 'package:dirassati/features/notifications/presentation/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  void _onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "LOGO",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 30
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Logout",
                  style: TextStyle(fontSize: 12),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logout();
                  },
                )
              ],
            )
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => currentIndex = index),
        children: const [
          AcceuilPage(),
          NotificationsPage(),
          ComptePage(),
        ],
      ),
      backgroundColor: Color(0xffEDEFFF),
      bottomNavigationBar: Navbar(
        currentIndex: currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}
