import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final Function(int) onIndexChanged;
  final int currentIndex;

  const Navbar({
    super.key,
    required this.onIndexChanged,
    required this.currentIndex,
  }) ;

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // If swiped left (negative velocity), go to the next item
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          if (widget.currentIndex < 2) {
            widget.onIndexChanged(widget.currentIndex + 1);
          }
        }
        // If swiped right (positive velocity), go to the previous item
        else if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          if (widget.currentIndex > 0) {
            widget.onIndexChanged(widget.currentIndex - 1);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                    context, 0, Icons.home, Icons.home_outlined, "Acceuil"),
                _buildNavItem(context, 1, Icons.notifications,
                    Icons.notifications_outlined, "Notifications"),
                _buildNavItem(context, 2, Icons.account_circle,
                    Icons.account_circle_outlined, "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData selectedIcon,
      IconData unselectedIcon, String label) {
    final bool isSelected = index == widget.currentIndex;

    return GestureDetector(
      onTap: () => widget.onIndexChanged(index),
      child: SizedBox(
        height: 65,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: isSelected ? 3 : 2,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? selectedIcon : unselectedIcon,
                  color: isSelected ? const Color(0xFF4D44B5) : Colors.black,
                  size: 24,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                  child: isSelected
                      ? Center(
                          key: ValueKey("label_$index"),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              label,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4D44B5),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          key: ValueKey("empty_$index"),
                          width: 0,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
