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
  int _currentIndex = 0;
  final PageController _pageController = PageController(keepPage: true);
  final List<Widget> _pages =  [
    _KeepAliveWrapper(child: AcceuilPage()),
    _KeepAliveWrapper(child: NotificationsPage()),
    _KeepAliveWrapper(child: ProfilePage()),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIndexChanged(int newIndex) {
    if (newIndex == _currentIndex) return;
    
    setState(() => _currentIndex = newIndex);
    _pageController.jumpToPage(
    // _pageController.animateToPage(
      newIndex,
      // duration: const Duration(milliseconds: 300),
      // curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper> 
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}