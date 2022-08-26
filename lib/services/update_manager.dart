import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';

class UpdateManager {
  static String downloadLink = 'https://tenz.surge.sh/nelo.apk';
  static String appLink = 'https://tenz.surge.sh/manganelo.json';
  static String version = '1.0.0';

  static Future<bool> isUpdateAvailable() async {
    var response = await http.get(Uri.parse(appLink));
    var remoteVersion = jsonDecode(response.body)['version'];

    return remoteVersion != version;
  }

  static downloadUpdate() {
    try {
      OtaUpdate().execute(downloadLink).listen(
        (OtaEvent event) {
          print(event);
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }
}
