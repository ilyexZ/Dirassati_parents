import 'package:flutter/material.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<Map<String, String>> data;

  const NotificationList({super.key, required this.data}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return NotificationCard(data: data[index]);
        },
      ),
    );
  }
}
