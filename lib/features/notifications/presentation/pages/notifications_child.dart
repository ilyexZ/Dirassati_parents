// lib/features/notifications/presentation/pages/notifications_child.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/features/notifications/domain/providers/notification_provider.dart';

class NotificationsChildPage extends ConsumerStatefulWidget {
  const NotificationsChildPage({super.key});

  @override
  ConsumerState<NotificationsChildPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsChildPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // static Absences data kept as-is
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

  Widget _buildNotificationCard(Map<String, dynamic> data) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['title']} — ${data['subtitle']}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data['child'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data['description'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
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

  Widget _buildConvocationsTab(List<Map<String, dynamic>> convocationsData) {
    if (convocationsData.isEmpty) {
      return const Center(child: Text('Aucune convocation pour l’instant.'));
    }
    return ListView.builder(
      itemCount: convocationsData.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(convocationsData[index]);
      },
    );
  }

  Widget _buildAbsencesTab() {
    return ListView.builder(
      itemCount: absencesData.length,
      itemBuilder: (context, index) {
        // cast your static Map<String,String> into Map<String,dynamic>
        return _buildNotificationCard(
            absencesData[index].cast<String, dynamic>());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the live notifications list
    final rawNotifications = ref.watch(notificationsProvider);
    // Ensure each item is a Map<String,dynamic>
    final convocationsData = rawNotifications
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildConvocationsTab(convocationsData),
                _buildAbsencesTab(),
              ],
            ),
          ),
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
