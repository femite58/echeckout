import 'dart:convert';

import 'package:echeckout/services/config_service.dart';
import 'package:http/http.dart' as http;

class GeneralSettingsService {
  static var _genS;
  String _baseUrl = ConfigService.baseUrl;

  get settings {
    return _genS;
  }

  Future<dynamic> getSettings() async {
    var res = await http.get(Uri.parse('${_baseUrl}general-settings'));
    _genS = json.decode(res.body)['data'];
    return _genS;
  }
}
