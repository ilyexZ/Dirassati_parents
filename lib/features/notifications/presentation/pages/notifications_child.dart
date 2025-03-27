import 'package:flutter/material.dart';

class NotificationsChildPage extends StatefulWidget {
  const NotificationsChildPage({super.key});

  @override
  State<NotificationsChildPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsChildPage>
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
    // Initialize the TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildNotificationCard(Map<String, String> data) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & subtitle
            Text(
              '${data['title']} — ${data['subtitle']}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              
            ),
            const SizedBox(height: 4),
            // Child info
            Text(
              data['child'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              data['description'] ?? '',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // Date
            Row(
              children: [
                const Text(
                  'Date de réception : ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  data['date'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvocationsTab() {
    return ListView.builder(
      itemCount: convocationsData.length,
      itemBuilder: (context, index) {
        final item = convocationsData[index];
        return _buildNotificationCard(item);
      },
    );
  }

  Widget _buildAbsencesTab() {
    return ListView.builder(
      itemCount: absencesData.length,
      itemBuilder: (context, index) {
        final item = absencesData[index];
        return _buildNotificationCard(item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // Back button color
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Convocations'),
                Tab(text: 'Absences'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Expanded so the tabs fill remaining space
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildConvocationsTab(),
                _buildAbsencesTab(),
              ],
            ),
          ),
          // Red banner at the bottom
          Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Les convocations envoyées via l’application sont obligatoires et doivent être respectées.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
