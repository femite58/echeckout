import 'dart:convert';

import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/services/config_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:rxdart/rxdart.dart';

import '../header_interceptor.dart';

class DashboardService with ChangeNotifier {
  static final _sideInfo = BehaviorSubject<Map?>.seeded(null);
  static final _dashInfo = BehaviorSubject<Map?>.seeded(null);
  Client http = AuthService().http;

  final String _baseUrl = ConfigService.baseUrl;

  BehaviorSubject get sideInfo {
    return _sideInfo;
  }

  BehaviorSubject get dashInfo {
    return _dashInfo;
  }

  setSideInfo(info) {
    _sideInfo.add(info);
  }

  Future<void> getDashboardInfo() async {
    var res = await http.get(Uri.parse('${_baseUrl}user/dashboard'));
    var resp = json.decode(res.body)['data'];
    setSideInfo({
      'usdBal': resp['usdBal'],
      'ngnBal': resp['ngnBal'],
      'topTransaction': resp['topTransaction'],
    });
    _dashInfo.add(resp);
  }
}
