import 'package:dirassati/features/notifications/presentation/widgets/notification_list.dart';
import 'package:dirassati/features/notifications/presentation/widgets/red_banner.dart';
import 'package:dirassati/features/notifications/presentation/widgets/static_data.dart';
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
  Widget _buildTabWithDivider(String text, bool last) {
    const double divderspacing = 20;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (last)
          Container(
            margin: EdgeInsets.only(right: divderspacing),
            width: 1,
            height: 20,
            color: Colors.grey[300],
          ),
        Expanded(
          child: Align(
            alignment: last ? Alignment.centerLeft : Alignment.centerRight,
            child: Tab(text: text),
          ),
        ),
        if (!last)
          Container(
            margin: EdgeInsets.only(left: divderspacing),
            width: 1,
            height: 20,
            color: Colors.grey[300],
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
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  // Change the overlay color when a tab is pressed
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.transparent;
                  }

                  return null; 
                }),
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
                  _buildTabWithDivider("Convocations", false),
                  _buildTabWithDivider("Absences", true),
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
          //const RedBanner(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
