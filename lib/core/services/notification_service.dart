import 'package:dirassati/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/core/auth_info_provider.dart';

Future<void> showStaticNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id', // channel id
    'your_channel_name', // channel name
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // notification id
    'Hello', // title
    'This is a static notification', // body
    platformChannelSpecifics,
    payload: 'Optional_Screen_Arguments',
  );
}
