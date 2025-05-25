import 'package:flutter/material.dart';

class BackgroundShapesToponly extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  
  const BackgroundShapesToponly({
    super.key, 
    required this.child1, 
    required this.child2
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Stack(
      children: [
        // Background shapes layer - painted behind everything
        Positioned.fill(
          child: CustomPaint(
            size: Size(screenWidth, screenHeight),
            painter: ShapesPainter(
              screenWidth: screenWidth, 
              screenHeight: screenHeight
            ),
          ),
        ),
        
        // Main layout structure with responsive back button
        Column(
          children: [
            // Top section with back button - using proportional flex values
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 20,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      // Making the back button size responsive too
                      minimumSize: WidgetStatePropertyAll(
                        Size(44 * (screenWidth / 412), 44 * (screenWidth / 412))
                      ),
                    ),
                  ),
                ),
              )
            ),
            
            // Main content area - takes up most of the screen
            Expanded(
              flex: 9,
              child: child1,
            ),
          ],
        ),
        
        // Overlay content positioned in center
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
    // Creating paint with reduced opacity for subtle background effect
    Paint paint1 = Paint()..color = shapeColor.withOpacity(0.1);

    // Using uniform scaling based on width to maintain perfect aspect ratios
    // This is the key to responsive design - one consistent scaling factor
    final scale = screenWidth / 412; // Reference width from your Figma design
    
    // Calculate the top ellipse diameter using consistent scaling
    // This ensures the circle remains perfectly round on all screen sizes
    final double topCircleDiameter = 500 * scale;

    // Position and draw the top ellipse
    // The negative Y offset creates the partially visible effect at the top
    Rect topEllipseRect = Rect.fromCenter(
      center: Offset(
        screenWidth / 2,    // Always center horizontally regardless of screen width
        -140 * scale,       // Vertical position scaled consistently with diameter
      ),
      width: topCircleDiameter,   // Perfect circle - same width and height
      height: topCircleDiameter,
    );
    
    // Draw the ellipse with the subtle background color
    canvas.drawOval(topEllipseRect, paint1);
    
    // Note: You had a comment about "Bottom Right Ellipses" but no implementation
    // This suggests you might want to add more shapes later. When you do,
    // make sure to use the same 'scale' factor for consistency
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}