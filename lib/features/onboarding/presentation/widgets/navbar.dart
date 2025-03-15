import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final Function(int) onIndexChanged;
  final int currentIndex;

  const Navbar({
    super.key,
    required this.onIndexChanged,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, -3),
        ),
      ]),
      child: BottomNavigationBar(
        elevation:10 ,
        currentIndex: currentIndex, // Use the passed currentIndex
        onTap: onIndexChanged, // Call the callback when a tab is tapped
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF4D44B5),
        ),

        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedLabelStyle: TextStyle(
            color: Color(0xFF4D44B5),
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            TextStyle(color: Colors.black, fontFamily: "Poppins"),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Accueil',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 1
                ? Icons.notifications
                : Icons.notifications_outlined),
            label: 'Notifications',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 2
                ? Icons.account_circle
                : Icons.account_circle_outlined),
            label: 'Compte',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
