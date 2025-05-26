import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<void> launchUrlInBrowser(String url) async {
    final uri = Uri.parse(url); // Use parse to throw if invalid

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success) {
      throw Exception('Could not launch $url');
    }
  }
}
