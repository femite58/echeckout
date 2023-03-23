import 'dart:async';

import 'package:echeckout/screens/auth/login_screen.dart';
import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/widgets/auth_layout.dart';
import 'package:echeckout/widgets/buttons.dart';
import 'package:echeckout/widgets/form_group.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../icons/custom_icons_icons.dart';
import '../../services/navigation_controller.dart';
import '../../services/cus_snack_bar.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey _formKey = GlobalKey();
  final List<Map<String, dynamic>> _fields = [
    {'focus': FocusNode(), 'field': 'email', 'touched': false, 'valid': false},
    {
      'focus': FocusNode(),
      'field': 'email_code',
      'touched': false,
      'valid': false
    },
    {
      'focus': FocusNode(),
      'field': 'password',
      'touched': false,
      'valid': false
    },
    {
      'focus': FocusNode(),
      'field': 'confirm_password',
      'touched': false,
      'valid': false
    },
  ];
  bool _submitting = false;
  bool _validForm = false;

  final List<String> _stageDesc = [
    'Please enter the email used for registration',
    'Please enter below the code sent to your email address',
    'Enter and confirm your new password'
  ];

  int _stage = 0;
  bool _resending = false;
  int m = 0;
  int s = 0;

  bool _isPass = true;

  Map _email = {};
  var _globTimer;

  Map _data = {};
  final Map _errors = {};
  final TextEditingController _ctrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  @override
  void dispose() {
    if (_globTimer != null) _globTimer.cancel();
    super.dispose();
  }

  bool _validate(field,
      {String pattern = '', caseSensitive = false, errMsg = ''}) {
    if (_data[field] == null || _data[field].isEmpty) {
      setState(() {
        _errors[field] = 'This field is required!';
      });
      return false;
    } else if (pattern.isNotEmpty) {
      var match = RegExp(r'' + pattern, caseSensitive: caseSensitive)
          .firstMatch(_data[field]);
      if (match == null) {
        setState(() {
          _errors[field] = errMsg;
        });
        return false;
      }
    }
    setState(() {
      _errors[field] = '';
    });
    return true;
  }

  _submit() {
    setState(() {
      _submitting = true;
    });
    _email = _data;
    AuthService().checkEmail(_data).then((id) {
      setState(() {
        _stage++;
        _submitting = false;
        _data = {};
        _data['id'] = id;
        _ctrl.clear();
        _fields[1]['focus'].requestFocus();
      });
    }).catchError((err) {
      setState(() {
        _errors['email'] = err;
        _submitting = false;
      });
    });
  }

  void _resendCode() {
    setState(() {
      _resending = true;
    });
    AuthService().forgotPassResendCode(_email).then((_) {
      setState(() {
        _resending = false;
      });
      CusSnackBar.showSnackBar(
        context,
        'Another verification code has been sent to your email',
      );
      _countDown(DateTime.now().add(const Duration(minutes: 1)));
    });
  }

  void _countDown(DateTime to) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _globTimer = timer;
      setState(() {
        var diff =
            to.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
        m = (diff / (1000 * 60)).floor();
        s = (diff % (1000 * 60) / 1000).floor();
        if (m == 0 && s == 0) {
          timer.cancel();
        }
      });
    });
  }

  _verifyCode() {
    setState(() {
      _submitting = true;
    });
    AuthService().verifyCode(_data).then((id) {
      setState(() {
        _stage++;
        _submitting = false;
        _data = {};
        _data['id'] = id;
        _fields[2]['focus'].requestFocus();
      });
    }).catchError((err) {
      setState(() {
        _errors['email_code'] = err;
        _submitting = false;
      });
    });
  }

  _changePass() {
    setState(() {
      _submitting = true;
    });
    AuthService().forgotPassChangePass(_data).then((id) {
      setState(() {
        _submitting = false;
      });
      NavigationController.popAndPushUntil(context, const LoginScreen(), '/');
    }).catchError((err) {
      setState(() {
        _submitting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var res = _fields.firstWhere((e) => !e['valid'],
        orElse: () => ({'missing': true}));
    setState(() {
      if (res['missing'] != null && res['missing']) {
        _validForm = true;
      } else {
        _validForm = false;
      }
    });
    _fields.forEach((f) {
      if (!f['focus'].hasListeners) {
        f['focus'].addListener(() {
          if (f['focus'].hasFocus) {
            f['touched'] = true;
          } else if (!f['focus'].hasFocus && f['touched']) {
            if (f['field'] == 'email') {
              f['valid'] = _validate(
                f['field'],
                pattern:
                    "^[a-z\\d.!#\$%&'*+/=?^_`{|}~-]+@[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?(?:\\.[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?)*\$",
                errMsg: 'Enter a valid email!',
              );
            } else if (f['field'] == 'password') {
              f['valid'] = _validate(
                f['field'],
                pattern: "[^a-z\\d]+",
                errMsg: 'Password must contain at least one special character!',
              );
            } else if (f['field'] == 'confirm_password') {
              var matches = RegExp(r'[^a-z\d]', caseSensitive: false)
                  .allMatches(_passCtrl.text);
              String toUse = _passCtrl.text;
              for (var each in matches.toList()) {
                var char = _passCtrl.text[each.start];
                toUse = toUse.replaceAll(char, '\\$char');
              }
              f['valid'] = _validate(
                f['field'],
                pattern: "^$toUse\$",
                caseSensitive: true,
                errMsg: 'Password mismatch error!',
              );
            } else {
              f['valid'] = _validate(f['field']);
            }
          }
          setState(() {});
        });
      }
    });
    return Scaffold(
        body: AuthLayout(
      focusNodes: _fields.map((e) => e['focus'] as FocusNode).toList(),
      title: 'Forgot Password',
      desc: _stageDesc[_stage],
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_stage == 0)
                Column(
                  children: [
                    FormGroup(
                      focusNode: _fields[0]['focus'],
                      label: 'Email Address',
                      errMsg: _errors['email'],
                      mb: 50,
                      onChanged: (val) {
                        _data['email'] = val?.trim();
                        // ignore: unnecessary_string_escapes
                        _fields[0]['valid'] = _validate(
                          _fields[0]['field'],
                          pattern:
                              "^[a-z\\d.!#\$%&'*+/=?^_`{|}~-]+@[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?(?:\\.[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?)*\$",
                          errMsg: 'Enter a valid email!',
                        );
                      },
                    ),
                    Button(
                      type: 'primBtn',
                      tapFunc: _submit,
                      text: 'Send Reset Code',
                      loading: _submitting,
                      disabled: !_fields[0]['valid'],
                    ),
                  ],
                ),
              if (_stage == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormGroup(
                      focusNode: _fields[1]['focus'],
                      label: 'Verification Code',
                      errMsg: _errors['email_code'],
                      onChanged: (val) {
                        _data['email_code'] = val;
                        _fields[1]['valid'] = _validate(
                          _fields[1]['field'],
                        );
                      },
                      controller: _ctrl,
                    ),
                    s != 0 || m != 0
                        ? Text(
                            '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: AppTheme.primCol,
                            ),
                          )
                        : GestureDetector(
                            onTap: _resending ? null : _resendCode,
                            child: _resending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: FittedBox(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppTheme.primCol),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      fontSize: AppTheme.fontSize,
                                      color: AppTheme.primCol,
                                    ),
                                  ),
                          ),
                    const SizedBox(height: 50),
                    Button(
                      type: 'primBtn',
                      tapFunc: _verifyCode,
                      text: 'Verify Code',
                      loading: _submitting,
                      disabled: !_fields[1]['valid'],
                    ),
                  ],
                ),
              if (_stage == 2)
                Column(
                  children: [
                    FormGroup(
                      focusNode: _fields[2]['focus'],
                      label: 'New Password',
                      errMsg: _errors['password'],
                      isPassword: true,
                      controller: _passCtrl,
                      onChanged: (val) {
                        _data['password'] = val;
                        // ignore: unnecessary_string_escapes
                        _fields[2]['valid'] = _validate(
                          _fields[2]['field'],
                          pattern: "[^a-z\\d]+",
                          errMsg:
                              'Password must contain at least one special character!',
                        );
                      },
                      onSubmit: (val) {
                        _fields[3]['focus'].requestFocus();
                      },
                    ),
                    FormGroup(
                      focusNode: _fields[3]['focus'],
                      label: 'Confirm Password',
                      errMsg: _errors['confirm_password'],
                      isPassword: _isPass,
                      mb: 50,
                      onChanged: (val) {
                        var matches = RegExp(r'[^a-z\d]', caseSensitive: false)
                            .allMatches(_passCtrl.text);
                        String toUse = _passCtrl.text;
                        for (var each in matches.toList()) {
                          var char = _passCtrl.text[each.start];
                          toUse = toUse.replaceAll(char, '\\$char');
                        }
                        _data['confirm_password'] = val;
                        _fields[3]['valid'] = _validate(
                          _fields[3]['field'],
                          pattern: "^$toUse\$",
                          caseSensitive: true,
                          errMsg: 'Password mismatch error!',
                        );
                      },
                      toggler: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPass = !_isPass;
                          });
                        },
                        icon: Icon(
                          _isPass ? CustomIcons.eye_6 : CustomIcons.eye_slash_1,
                          size: _isPass ? 13 : 16,
                        ),
                      ),
                    ),
                    Button(
                      type: 'primBtn',
                      tapFunc: _changePass,
                      text: 'Change Password',
                      loading: _submitting,
                      disabled: !_fields[2]['valid'] || !_fields[3]['valid'],
                    ),
                  ],
                ),
              const SizedBox(height: 25),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Remember password? Login',
                    style: TextStyle(
                      color: AppTheme.primCol,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
