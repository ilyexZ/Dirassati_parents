import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<void> launchUrlInBrowser(String url) async {
    final uri = Uri.tryParse(url);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch URL: $url');
    }
  }
}
