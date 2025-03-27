import 'package:flutter/material.dart';

class BackgroundShapesToponly extends StatelessWidget {
  final Widget child1;
  final Widget child2;

  const BackgroundShapesToponly(
      {super.key, required this.child1, required this.child2});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            size: Size(screenWidth, screenHeight),
            painter: ShapesPainter(
                screenWidth: screenWidth, screenHeight: screenHeight),
          ),
        ),
        Column(
          children: [
            Expanded(
                flex: 2,
                child: SizedBox(
                  height: 20,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: BackButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.white)),
                    ),
                  ),
                )),
            Expanded(
              flex: 9,
              child: child1,
            ),
          ],
        ),
        Positioned(
          child: Center(
            child: child2,
          ),
        ),
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
    Paint paint1 = Paint()..color = shapeColor.withOpacity(0.1);

    // Scaling based on Figma's reference height
    //final scaleH = screenWidth / 412;
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
