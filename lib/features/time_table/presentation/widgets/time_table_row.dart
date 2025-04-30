import 'package:flutter/material.dart';

class TimeTableRow extends StatelessWidget {
  final List<String> content;
  const TimeTableRow({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5), // Top border
          bottom: BorderSide(color: Colors.grey, width: 0.5), // Bottom border
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4), // Optional padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          twoCol(
            child1: content[0],
            child2: content[1],
          ),
          twoCol(
            child1: content[2],
            child2: content[3],
            labelColor: Color(0XFF4D44B5),
            centered: true,
          ),
        ],
      ),
    );
  }
}


class twoCol extends StatelessWidget {
  final String child1;
  final String child2;
  final Color? labelColor;
  final bool centered;

  const twoCol({
    super.key,
    required this.child1,
    required this.child2,
    this.labelColor,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
      child: Column(
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            child1,
            style: TextStyle(
              color: labelColor ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),
          ),
          Text(
            child2,
            style: const TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
