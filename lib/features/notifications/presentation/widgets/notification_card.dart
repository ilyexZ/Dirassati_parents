import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, String> data;

  const NotificationCard({super.key, required this.data}) ;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & subtitle separated
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  data['title'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 40),
                // Subtitle
                Text(
                  data['subtitle'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Child info
            Text(
              data['child'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              data['description'] ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.grey),

              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Divider(),
            // Date row
            Row(
              children: [
                const Text(
                  softWrap: true,
                  maxLines: 2,
                  'Date de réception : ',
                  style: TextStyle(
                    
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  data['date'] ?? '',
                  softWrap: true,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
