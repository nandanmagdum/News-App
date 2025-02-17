import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<void> openUrlInBrowser({required String link}) async {
    Uri uri = Uri.parse(link);
    if (await launchUrl(uri)) {
      throw Exception("Could not launch url");
    }
  }
}
