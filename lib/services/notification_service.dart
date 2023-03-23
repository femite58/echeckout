import 'dart:async';
import 'dart:convert';

import 'package:echeckout/main.dart';
import 'package:echeckout/screens/auth/login_screen.dart';
import 'package:echeckout/services/config_service.dart';
import 'package:echeckout/services/navigation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:echeckout/services/header_interceptor.dart';

import 'auth_service.dart';
import 'socket_service.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  Map? _auth;
  Client http = AuthService().http;
  final String _baseUrl = ConfigService.baseUrl;
  static final IO.Socket _socket = SocketService.socket;
  static String? token;
  static String? _firebaseToken;
  static String? _nativeToken;
  static List disputes = [];

  static final _notifications = BehaviorSubject<List?>.seeded(null);

  BehaviorSubject<List?> get notifications {
    return _notifications;
  }

  NotificationService() {
    _auth = AuthService().auth.value;
  }

  resetNotifs() {
    page = 1;
    count = 0;
    limit = 10;
    allNotifs.add(null);
  }

  getNotifs() async {
    var user = _auth?['username'];
    if (notifHandlers[user] == null) {
      notifHandlers[user] = (notifs) {
        _notifications.add(notifs);
      };
      _socket.on('notifications', notifHandlers[user]);
    }
    // await AwesomeNotificationsFcm().subscribeToTopic(user);
    _socket.emit('notifications', [_auth, _firebaseToken]);
  }

  static Map notifHandlers = {};

  leaveNotif() async {
    var user = _auth?['username'];
    notifHandlers[_auth?['username']] = null;
    _socket.emit('leaveNotif', _auth);
  }

  static int page = 1;
  static int limit = 10;
  static int count = 0;

  static BehaviorSubject<List?> allNotifs = BehaviorSubject<List?>.seeded(null);

  Future<dynamic> getAllNotifs() async {
    var res = await http
        .get(Uri.parse('${_baseUrl}user/all-notification/$limit/$page'));
    var data = json.decode(res.body)['data'];
    var tempnotif = allNotifs.value ?? [];
    tempnotif.addAll(data['data'] as List);
    allNotifs.add(tempnotif);
    count = data['counts'];
    return data;
  }

  Future<dynamic> readNotif(id) async {
    var res =
        await http.get(Uri.parse('${_baseUrl}user/notification/read/$id'));
    var jres = json.decode(res.body);
    notifications.add(jres['data']);
  }

  Future<dynamic> readAll(limit, page) async {
    var res = await http
        .get(Uri.parse('${_baseUrl}user/notification/read-all/$limit/$page'));
    notifications.add([]);
  }
}
