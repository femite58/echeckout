import 'dart:convert';

import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/services/config_service.dart';
import 'package:http/http.dart';

class TransactionsService {
  final Client _http = AuthService().http;
  final String _baseUrl = ConfigService.baseUrl;

  Future<dynamic> getTrans(limit, page, {role = 'all', date = 'all'}) async {
    var res = await _http.get(
        Uri.parse('${_baseUrl}user/transactions/$limit/$page/$role/$date'));
    return json.decode(res.body)['data'];
  }
}
