import 'package:dirassati/features/notifications/presentation/widgets/notification_card.dart';
import 'package:dirassati/features/time_table/presentation/widgets/time_table_row.dart';
import 'package:flutter/material.dart';

class TimeTableDay extends StatelessWidget {
  const TimeTableDay({super.key});
  static List<List<String>> schedule = [
    ["Science", "Mr LYASS", "8:00-9:00", "salle 4"],
    ["Math", "Mr ISACCC", "9:00-10:00", "salle 4"]
  ];

  @override
  Widget build(BuildContext context) {
  var dayList =schedule.map((day) => TimeTableRow(content: day)).toList();
   
    return Column(
      children: [
        ...dayList,
        ...dayList,
        Container(
          margin: EdgeInsets.all(12),
          child: Text(
            "Pause de l'après-midi",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        ...dayList,
      ],
    );
  }
}
