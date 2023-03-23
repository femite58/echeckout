import 'dart:convert';

import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/services/general_settings_service.dart';
import 'package:http/http.dart';

import '../config_service.dart';

class BanksService {
  late List _banks = [];

  late Client http;
  final String _baseUrl = ConfigService.baseUrl;

  BanksService() {
    http = AuthService().http;
    _banks = GeneralSettingsService().settings['bankList'];
  }

  findBank(code) {
    return _banks.firstWhere((el) => el['code'] == code);
  }

  Future<dynamic> getAccName({bank_code, account_number}) async {
    var res = await http.get(Uri.parse(
        '${_baseUrl}user/account-settings/verify-account-number/${account_number}/${bank_code}'));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }
}
