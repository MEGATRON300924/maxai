import 'package:http/http.dart' as http;

class LinkPreviewService {
  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>?> getPreview(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 400) return null;
      final html = response.body;
      String? meta(String property) {
        final pattern = RegExp('<meta[^>]+(?:property|name)=["\\\']$property["\\\'][^>]+content=["\\\']([^"\\\']*)["\\\']', caseSensitive: false);
        return pattern.firstMatch(html)?.group(1);
      }
      final title = meta('og:title') ?? RegExp('<title[^>]*>(.*?)</title>', caseSensitive: false, dotAll: true).firstMatch(html)?.group(1)?.trim();
      final description = meta('og:description') ?? meta('description');
      final image = meta('og:image');
      final preview = <String, dynamic>{'url': url, if (title != null) 'title': title, if (description != null) 'description': description, if (image != null) 'image': image};
      _cache = preview;
      return preview;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getCached() => _cache;
}
