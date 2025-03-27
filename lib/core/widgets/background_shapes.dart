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
            child: const Center(
              child: Text(
                'LOGO',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
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
    Paint paint2 = Paint()..color = shapeColor
      ..style = PaintingStyle.stroke // Outline only
      ..strokeWidth = 2; // Border thickness

    // Scaling based on Figma's reference height
    final scaleH = screenWidth / 412;
    final scaleV = screenHeight / 917;

    final double circle1diam = scaleV * 500;

    // Top Ellipse
    Rect ellipseRect = Rect.fromCenter(
      center: Offset(screenWidth / 2, -140 * scaleV),
      width: circle1diam,
      height: circle1diam,
    );
    canvas.drawOval(ellipseRect, paint1);

    // Bottom Right Ellipses
    Rect ellipseRect2 = Rect.fromCenter(
      center: Offset((261 + 366 / 2) * scaleH, (651 + 366 / 2) * scaleV),
      width: 366 * scaleV,
      height: 366 * scaleV,
    );
    canvas.drawOval(ellipseRect2, paint1);

    Rect ellipseRect25 = Rect.fromCenter(
      center: Offset((279 + 366 / 2) * scaleH, (651 + 366 / 2) * scaleV),
      width: 366 * scaleV,
      height: 366 * scaleV,
    );
    canvas.drawOval(ellipseRect25, paint2);

    // Bottom Left Ellipse
    Rect ellipseRect3 = Rect.fromCenter(
      center: Offset((-44 + 366 / 2) * scaleH, (763 + 366 / 2) * scaleV),
      width: 366 * scaleV,
      height: 366 * scaleV,
    );
    canvas.drawOval(ellipseRect3, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
