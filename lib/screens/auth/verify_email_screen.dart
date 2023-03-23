import 'dart:async';
import 'dart:math' as math;

import 'package:echeckout/screens/auth/create_pin_screen.dart';
import 'package:echeckout/screens/auth/login_screen.dart';
import 'package:echeckout/screens/user/dashboard_screen.dart';
import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/widgets/auth_layout.dart';
import 'package:echeckout/widgets/page_loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../services/navigation_controller.dart';
import '../../services/cus_snack_bar.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../services/cus_snack_bar.dart';
import '../../widgets/form_group.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  var _auth;
  List _fields = [
    {
      'focus': FocusNode(),
      'valid': false,
      'touched': false,
      'field': 'email_code'
    },
  ];

  var _authSub;

  @override
  void initState() {
    _authSub = AuthService().auth.listen((auth) {
      _auth = auth;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSub.cancel();
    if (_globTimer != null) _globTimer.cancel();
    super.dispose();
  }

  bool _validForm = false;
  bool _submitting = false;
  bool _resending = false;

  var _globTimer;

  int m = 0;
  int s = 0;

  Map _errors = {};

  Map _data = {};

  bool _validate(field) {
    if (_data[field] == null || _data[field].isEmpty) {
      setState(() {
        _errors[field] = 'This field is required!';
      });
      return false;
    }
    setState(() {
      _errors[field] = '';
    });
    return true;
  }

  void _submit() {
    setState(() {
      _submitting = true;
    });
    AuthService().verifyEmail(_data).then((value) {
      setState(() {
        _submitting = false;
      });
      NavigationController.replaceNav(
        context,
        const CreatePinScreen(),
        CreatePinScreen.routeName,
      );
    }).catchError((err) {
      setState(() {
        _submitting = false;
        _errors['email_code'] = err.toString();
      });
    });
  }

  void _resendCode() {
    setState(() {
      _resending = true;
    });
    AuthService().resendCode().then((_) {
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
            f['valid'] = _validate(f['field']);
          }
          setState(() {});
        });
      }
    });
    return Scaffold(
      body: _auth == null
          ? const PageLoader()
          : AuthLayout(
              focusNodes: _fields.map((e) => e['focus'] as FocusNode).toList(),
              title: 'Confirm Email/Phone',
              desc: Text.rich(
                TextSpan(
                  text:
                      'Verification code has been sent to your email address and WhatsApp Phone Number',
                  children: [
                    TextSpan(
                      text: '${_auth['email']}',
                      style: const TextStyle(
                        color: Color(0xFF011B33),
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: AppTheme.fontSize,
                  color: Color(0xB1011B33),
                ),
              ),
              body: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormGroup(
                      focusNode: _fields[0]['focus'],
                      label: 'Enter Code',
                      onChanged: (val) {
                        _data['email_code'] = val;
                        _fields[0]['valid'] = _validate('email_code');
                      },
                      onSubmit: (val) {
                        _submit();
                      },
                      errMsg: _errors['email_code'],
                    ),
                    s != 0 || m != 0
                        ? Text(
                            '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                            style: const TextStyle(
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
                      tapFunc: _submit,
                      text: 'Verify Code',
                      loading: _submitting,
                      disabled: !_validForm,
                    ),
                    const SizedBox(height: 25),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => NavigationController.slideBothSideways(
                          context,
                          const LoginScreen(),
                        ),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: AppTheme.primCol,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
