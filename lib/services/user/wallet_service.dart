import 'dart:convert';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../auth_service.dart';
import '../config_service.dart';
import '../socket_service.dart';

class WalletService {
  final Client _http = AuthService().http;
  final String _baseUrl = ConfigService.baseUrl;

  // static final IO.Socket _socket = SocketService.socket;

  static final _depositRes = BehaviorSubject<Map?>.seeded(null);
  static final _cards = BehaviorSubject<List?>.seeded(null);
  static final _accInfo = BehaviorSubject<Map?>.seeded(null);

  BehaviorSubject<Map?> get depositRes => _depositRes;
  BehaviorSubject<List?> get cards => _cards;
  BehaviorSubject<Map?> get accInfo => _accInfo;

  // getDepositResp() {
  //   _socket.on('deposit', (res) {
  //     _depositRes.add(res);
  //   });
  // }

  Future<dynamic> getSavedCards() async {
    var res = await _http.get(Uri.parse('${_baseUrl}user/all-cards'));
    var data = json.decode(res.body)['data'];
    _cards.add(data);
    return data;
  }

  Future<dynamic> deposit(data) async {
    var res = await _http.post(
        Uri.parse('${_baseUrl}user/wallet/credit-wallet'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> withdraw(data) async {
    var res = await _http.post(Uri.parse('${_baseUrl}user/withdrawal/request'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> transfer(data) async {
    var res = await _http.post(Uri.parse('${_baseUrl}user/transfer/create'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> validateOTP(data) async {
    var res = await _http.post(Uri.parse('${_baseUrl}user/wallet/validateotp'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> deleteCard(id) async {
    var res =
        await _http.delete(Uri.parse('${_baseUrl}user/all-cards/delete/$id'));
    return res;
  }

  Future<dynamic> deleteBank(id) async {
    var res = await _http
        .delete(Uri.parse('${_baseUrl}user/account-settings/delete-bank/$id'));
    getAccInfo();
    return res;
  }

  Future<dynamic> deleteUser(id) async {
    var res = await _http
        .delete(Uri.parse('${_baseUrl}user/transfer/saved-user/delete/$id'));
    getAccInfo();
    return res;
  }

  Future<dynamic> checkAccNum(code, accnum) async {
    var res = await _http.get(Uri.parse(
        '${_baseUrl}user/account-settings/verify-account-number/$accnum/$code'));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> getAccInfo() async {
    var res =
        await _http.get(Uri.parse('${_baseUrl}user/account-settings/bank'));
    var data = json.decode(res.body)['data'];
    _accInfo.add(data);
    return data;
  }
}
