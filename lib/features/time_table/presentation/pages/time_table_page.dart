import 'package:dirassati/features/time_table/presentation/widgets/time_table_day.dart';
import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  static List<String> joursDeLaSemaine = [
    'Dimanche',
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
  ];

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // <-- Here

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TimeTablePage.joursDeLaSemaine.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // Always dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //surfaceTintColor: Colors.transparent,
        title: const Text("Emplois du temps",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          labelColor: const Color(0xFF4D44B5),
          indicatorColor: const Color(0xFF4D44B5),
          unselectedLabelColor: Colors.grey,

          controller: _tabController, // <-- Here
          tabs: TimeTablePage.joursDeLaSemaine
              .map((jour) => Tab(text: jour))
              .toList(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: TabBarView(
          controller: _tabController, // <-- Here
          children: TimeTablePage.joursDeLaSemaine
              .map((jour) => Center(child: TimeTableDay()))
              .toList(),
        ),
      ),
    );
  }
}
