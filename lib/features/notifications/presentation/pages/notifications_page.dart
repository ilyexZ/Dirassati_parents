import 'package:dirassati/features/notifications/domain/providers/notification_provider.dart';
import 'package:dirassati/features/notifications/presentation/widgets/notification_list.dart';
import 'package:dirassati/features/notifications/presentation/widgets/red_banner.dart';
import 'package:dirassati/features/notifications/presentation/widgets/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifications page showing convocations and absences
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  Widget _buildTabWithDivider(String text, bool isLast) {
    const double spacing = 20;
    return Row(
      children: [
        if (isLast)
          Container(
            margin: const EdgeInsets.only(right: spacing),
            width: 1,
            height: 20,
            color: Colors.grey[300],
          ),
        Expanded(
          child: Align(
            alignment: isLast ? Alignment.centerLeft : Alignment.centerRight,
            child: Tab(text: text),
          ),
        ),
        if (!isLast)
          Container(
            margin: const EdgeInsets.only(left: spacing),
            width: 1,
            height: 20,
            color: Colors.grey[300],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch provider that returns List<Map<String, String>>
    final rawNotifications = ref.watch(notificationsProvider);

    // Convert each Map<dynamic, dynamic> to Map<String, String>
    final absenceItems = rawNotifications
        .map((n) => n.cast<String, String>())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
                controller: _tabController,
                labelColor: const Color(0xFF4D44B5),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF4D44B5),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => states.contains(MaterialState.pressed)
                        ? Colors.transparent
                        : null),
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                tabs: [
                  Tab(text:'Convocations'),
                  Tab(text:'Absences'),
                ],
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Static convocations
                NotificationList(data: convocationsData),
                // Dynamic absences
                NotificationList(data: absenceItems),
              ],
            ),
          ),
          const RedBanner(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
