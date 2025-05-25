import 'package:flutter/material.dart';

class BackgroundShapes extends StatelessWidget {
  final Widget child;
  const BackgroundShapes({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            size: Size(screenWidth, screenHeight),
            painter: ShapesPainter(screenWidth: screenWidth, screenHeight: screenHeight),
          ),
        ),
        Positioned(
          top: 60 * screenHeight / 917,
          left: 0,
          right: 0,
          child: Center(
            // Making the logo responsive too
            child: Image.asset(
              "assets/img/logo_h.png",
              width: 300 * (screenWidth / 412), // Scale logo width proportionally
              height: 30 * (screenWidth / 412),  // Scale logo height proportionally
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class ShapesPainter extends CustomPainter {
  final double screenHeight;
  final double screenWidth;
  static Color shapeColor = Color(0xFF7B88F0);

  ShapesPainter({required this.screenWidth, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()..color = shapeColor.withOpacity(0.5);
    Paint paint2 = Paint()
      ..color = shapeColor
      ..style = PaintingStyle.stroke // Outline only
      ..strokeWidth = 2; // Border thickness

    // Use uniform scaling based on width to maintain aspect ratios
    // This ensures shapes keep their proportions across all screen sizes
    final scale = screenWidth / 412; // Reference width from your Figma design
    
    // Scale stroke width proportionally too for consistency
    paint2.strokeWidth = 2 * scale;

    // Top Ellipse - positioned and sized proportionally
    final double topCircleDiameter = 500 * scale; // Consistent scaling
    Rect topEllipseRect = Rect.fromCenter(
      center: Offset(
        screenWidth / 2, // Center horizontally
        -140 * scale,    // Position vertically with same scale
      ),
      width: topCircleDiameter,
      height: topCircleDiameter,
    );
    canvas.drawOval(topEllipseRect, paint1);

    // Bottom Right Ellipses - maintaining consistent scaling
    final double bottomCircleDiameter = 366 * scale;
    
    // First bottom right ellipse (filled)
    Rect bottomRightEllipse1 = Rect.fromCenter(
      center: Offset(
        (261 + 366 / 2) * scale, // X position scaled consistently
        screenHeight - (917 - (651 + 366 / 2)) * scale, // Y position relative to bottom
      ),
      width: bottomCircleDiameter,
      height: bottomCircleDiameter,
    );
    canvas.drawOval(bottomRightEllipse1, paint1);

    // Second bottom right ellipse (outline) - slightly offset
    Rect bottomRightEllipse2 = Rect.fromCenter(
      center: Offset(
        (279 + 366 / 2) * scale, // X position scaled consistently
        screenHeight - (917 - (651 + 366 / 2)) * scale, // Y position relative to bottom
      ),
      width: bottomCircleDiameter,
      height: bottomCircleDiameter,
    );
    canvas.drawOval(bottomRightEllipse2, paint2);

    // Bottom Left Ellipse
    Rect bottomLeftEllipse = Rect.fromCenter(
      center: Offset(
        (-44 + 366 / 2) * scale, // X position scaled consistently
        screenHeight - (917 - (763 + 366 / 2)) * scale, // Y position relative to bottom
      ),
      width: bottomCircleDiameter,
      height: bottomCircleDiameter,
    );
    canvas.drawOval(bottomLeftEllipse, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}