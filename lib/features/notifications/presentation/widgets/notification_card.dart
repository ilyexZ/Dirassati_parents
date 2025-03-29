import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, String> data;

  const NotificationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE1E3E8), width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & subtitle separated
            buildRow(data['title'] ?? '', data['subtitle'] ?? ""),
            const SizedBox(height: 4),
            // Child info
            buildRow("Enfant concernée", data['child'] ?? ""),

            const SizedBox(height: 4),
            // Description

            buildRow(null, data['description'] ?? ""),
            const SizedBox(height: 8),
            const Divider(),
            buildRow(
              'Date de réception',
              data['date'] ?? '',
            ),
            // Date row
          ],
        ),
      ),
    );
  }
}

Widget buildRow(String? label, String data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      if (label != null)
        Expanded(
            child: Text(
          "$label:",
          style: labelstyle,
        )),
      Expanded(
          child: Text(
        data,
        style: datastyle,
        softWrap: true,
        maxLines: 2,
      )),
    ],
  );
}

const TextStyle labelstyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 11,
);
const datastyle = TextStyle(
  fontSize: 10,
  color: Colors.grey,
  fontWeight: FontWeight.w400,
);
