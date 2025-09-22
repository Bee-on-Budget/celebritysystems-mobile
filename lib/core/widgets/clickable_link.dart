import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget clickableLinkWidget({
  required IconData icon,
  required String title,
  required String? url,
  Color? iconColor,
  Color? cardColor,
}) {
  final uri = Uri.tryParse(url ?? "");
  final isValid =
      uri != null && (uri.isScheme("http") || uri.isScheme("https"));

  return Card(
    color: cardColor,
    elevation: 1.5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.redAccent),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: GestureDetector(
        onTap: () async {
          if (isValid && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint("Invalid or unlaunchable URL: $url");
          }
        },
        child: Text(
          'View the location on Google Maps',
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),
  );
}
