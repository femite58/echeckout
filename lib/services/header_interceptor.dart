import 'package:flutter/material.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/models/request_data.dart';

class HeaderInterceptor implements InterceptorContract {
  var _auth;
  static late BuildContext ctx;
  HeaderInterceptor(auth) {
    _auth = auth;
  }
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (_auth != null && _auth['token'] != null) {
      data.headers['Authorization'] = 'Bearer ${_auth['token']}';
      return data;
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      Navigator.of(ctx).pushReplacementNamed('/');
    }
    return data;
  }
}
