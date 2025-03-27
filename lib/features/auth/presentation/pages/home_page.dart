import 'package:flutter/material.dart';
import 'package:dirassati/features/acceuil/presentation/pages/acceuil_page.dart';
import 'package:dirassati/features/profile/presentation/pages/profile_page.dart';
import 'package:dirassati/features/notifications/presentation/pages/notifications_page.dart';
import 'package:dirassati/core/widgets/navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  void _onIndexChanged(int newIndex) {
    int previousIndex = currentIndex;
    setState(() {
      currentIndex = newIndex;
    });
    
    // If the pages are not adjacent, jump directly
    if ((newIndex - previousIndex).abs() > 1) {
      _pageController.jumpToPage(newIndex);
    } else {
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        
        controller: _pageController,
        onPageChanged: (index) => setState(() => currentIndex = index),
        children: const [
          AcceuilPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
      ),
      backgroundColor: const Color(0xffEDEFFF),
      bottomNavigationBar: Navbar(
        currentIndex: currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}
