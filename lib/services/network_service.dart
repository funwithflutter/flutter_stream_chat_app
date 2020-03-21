import 'package:http/http.dart' as http;

Future<bool> isValidImageUrl(String url) async {
  try {
    final response = await http.head(url);
    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType == 'image/jpeg' || contentType == 'image/png') {
        return true;
      }
    }
    return false;
  } on Exception catch (e) {
    print(e);
    return false;
  }
}
