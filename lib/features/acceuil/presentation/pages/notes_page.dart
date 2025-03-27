import 'package:dirassati/features/acceuil/presentation/widgets/notes_tab.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Notes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  //overlayColor: null,
                  //dragStartBehavior: DragStartBehavior.start,
                  
                  dividerColor: Colors.transparent,
                  labelColor: const Color(0xFF4D44B5),
                  indicatorColor: const Color(0xFF4D44B5),
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey,
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: const EdgeInsets.only(bottom: 12),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: [
                    _buildTabWithDivider("devoir 1"),
                    _buildTabWithDivider("devoir 2"),
                    _buildTabWithDivider("Examen"),
                    const Tab(text: "Evaluation"), // Last tab without divider
                  ],
                  tabAlignment: TabAlignment.fill,
                ),
                Transform.translate(
                  offset: const Offset(0, -12),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              NotesTab(title: "devoir 1"),
              NotesTab(title: "devoir 2"),
              NotesTab(title: "Examen"),
              NotesTab(title: "Evaluation"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabWithDivider(String text) {
    return Row(
      children: [
        Expanded(child: Tab(text: text)),
        Container(
          width: 1,
          height: 20,
          color: Colors.grey[300],
          margin: const EdgeInsets.symmetric(horizontal: 0),
        ),
      ],
    );
  }
}