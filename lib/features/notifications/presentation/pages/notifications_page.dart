import 'package:dirassati/features/notifications/presentation/widgets/notification_list.dart';
import 'package:dirassati/features/notifications/presentation/widgets/red_banner.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Example data for the Convocations tab
  final List<Map<String, String>> convocationsData = [
    {
      'title': 'Mr. LastName',
      'subtitle': 'mauvaise conduite',
      'child': 'Enfant concernée : LastName First',
      'description': 'Vous devriez venir pour que nous réglions ce problème.',
      'date': '25 Janvier 2025 - 9:00 AM',
    },
    {
      'title': 'Mr. LastName',
      'subtitle': 'mauvaise conduite',
      'child': 'Enfant concernée : LastName First',
      'description': 'Vous devriez venir pour que nous réglions ce problème.',
      'date': '25 Janvier 2025 - 9:00 AM',
    },
    {
      'title': 'Mr. LastName',
      'subtitle': 'mauvaise conduite',
      'child': 'Enfant concernée : LastName First',
      'description': 'Vous devriez venir pour que nous réglions ce problème.',
      'date': '25 Janvier 2025 - 9:00 AM',
    },
  ];

  // Example data for the Absences tab
  final List<Map<String, String>> absencesData = [
    {
      'title': 'Mr. LastName',
      'subtitle': 'absence injustifiée',
      'child': 'Enfant concernée : LastName First',
      'description': 'Votre enfant a été absent sans justificatif.',
      'date': '20 Février 2025 - 8:30 AM',
    },
    {
      'title': 'Mr. LastName',
      'subtitle': 'absence injustifiée',
      'child': 'Enfant concernée : LastName First',
      'description': 'Votre enfant a été absent sans justificatif.',
      'date': '18 Février 2025 - 10:00 AM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Helper method to build a tab with a vertical divider to its right
  Widget _buildTabWithDivider(String text) {
    return Row(
      children: [
        Expanded(
          child: Tab(text: text),
        ),
        Container(
          width: 1,
          height: 20,
          color: Colors.grey[300],
          // margin can be adjusted if you want spacing around the divider
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFF4D44B5),
                indicatorColor: const Color(0xFF4D44B5),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                unselectedLabelColor: Colors.grey,
                controller: _tabController,

                labelPadding: EdgeInsets.zero,
                // Moves the indicator line up or down
                indicatorPadding: const EdgeInsets.only(bottom: 12),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  // First tab with divider to the right
                  _buildTabWithDivider("Convocations"),

                  // Second tab (last tab) - no divider
                  const Tab(text: "Absences"),
                ],
                tabAlignment: TabAlignment.fill,
              ),
              // This divider sits just below the tabs
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
      body: Column(
        children: [
          // TabBarView for content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NotificationList(data: convocationsData),
                NotificationList(data: absencesData),
              ],
            ),
          ),
          // The red banner at the bottom
          const RedBanner(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
