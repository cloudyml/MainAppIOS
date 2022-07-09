import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openLink({required String Url}) => _launchUrl(Url);

  static Future _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}