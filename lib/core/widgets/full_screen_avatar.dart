import 'dart:ui';
import 'package:flutter/material.dart';

class FullScreenAvatar extends StatelessWidget {
  final Widget? child;
  final Object? tag;
  const FullScreenAvatar({
    super.key,
    this.child,
    this.tag,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            // Blurred, semi-transparent background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            // Centered circular image with Hero transition
            Center(
              child: Hero(

                tag: tag ?? "lol",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 300,
                    color: Colors
                        .transparent, // Optional background color for the circle
                    child: child??Text("lol"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
