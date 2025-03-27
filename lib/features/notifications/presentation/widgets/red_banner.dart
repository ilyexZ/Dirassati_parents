import 'package:flutter/material.dart';

class RedBanner extends StatelessWidget {
  const RedBanner({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      
      borderRadius: BorderRadius.circular(8), // Ensures corners are rounded
      child: Container(
        margin: const EdgeInsets.fromLTRB(8,0,8,20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // Ensure background is visible
          border: Border.all(color: Colors.grey, width: 1), // Grey border for all sides
          borderRadius: BorderRadius.circular(8), // Round the corners
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
                children: [
                  const Icon(Icons.warning_rounded, size: 25, color: Colors.red),
                  const SizedBox(width: 8), // Add spacing between icon and text
                  Expanded(
                    child: Text(
                      'Les convocations envoyées via l’application sont obligatoires et doivent être respectées.',
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ), // Match the parent container's radius
              child: Container(
                width: double.infinity,
                height: 4,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
