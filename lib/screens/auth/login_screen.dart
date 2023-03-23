import 'dart:async';

import 'package:echeckout/helpers/text_transform.dart';
import 'package:echeckout/icons/custom_icons_icons.dart';
import 'package:echeckout/screens/auth/forgot_password_screen.dart';
import 'package:echeckout/screens/auth/register_screen.dart';
import 'package:echeckout/screens/auth/verify_email_screen.dart';
import 'package:echeckout/screens/user/dashboard_screen.dart';
import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/services/navigation_controller.dart';
import 'package:echeckout/services/notification_service.dart';
import 'package:echeckout/widgets/auth_layout.dart';
import 'package:echeckout/widgets/buttons.dart';
import 'package:echeckout/widgets/form_group.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'two_fa_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _userFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final List<Map<String, dynamic>> _focusNodes = [
    {'focus': FocusNode(), 'field': 'user', 'touched': false, 'valid': false},
    {
      'focus': FocusNode(),
      'field': 'password',
      'touched': false,
      'valid': false
    }
  ];
  bool _submitting = false;

  Map _data = {};

  bool _passField = true;

  bool _validForm = false;

  var _auth;

  late StreamSubscription _authSub;

  @override
  void dispose() {
    _focusNodes.forEach((f) {
      f['focus'].dispose();
    });
    _authSub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _authSub = AuthService().auth.stream.listen((auth) {
      if (auth != null) {
        setState(() {
          _auth = auth;
          _data['user'] = auth['username'];
          _focusNodes[0]['valid'] = true;
        });
      }
    });
    super.initState();
  }

  void _submit() {
    setState(() {
      _submitting = true;
    });
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _submitting = false;
      });
      NavigationController.replaceNav(
        context,
        const DashboardScreen(),
        DashboardScreen.routeName,
      );
    });
    // AuthService().login(_data).then((value) {
    //   if (!mounted) return;
    //   setState(() {
    //     _submitting = false;
    //   });
    //   _authSub.cancel();
    //   AuthService().updateAuth(value);
    //   NotificationService().getNotifs();
    //   if (value['email_verify'].toString() != '1') {
    //     NavigationController.slideBothSideways(
    //         context, const VerifyEmailScreen());
    //   } else if (value['two_authenticate'].toString() == '1' &&
    //       value['token'] == null) {
    //     NavigationController.slideBothSideways(
    //       context,
    //       const TwoFaScreen(),
    //     );
    //   } else if (value['pin'] == null || value['pin'].isEmpty) {
    //     NavigationController.replaceNav(
    //       context,
    //       const CreatePinScreen(),
    //       CreatePinScreen.routeName,
    //     );
    //   } else {
    //     NavigationController.replaceNav(
    //       context,
    //       const DashboardScreen(),
    //       DashboardScreen.routeName,
    //     );
    //   }
    // }).catchError((err) {
    //   if (!mounted) return;
    //   setState(() {
    //     _submitting = false;
    //     if (err.contains(RegExp(r'password', caseSensitive: false))) {
    //       _errors['password'] = err;
    //     } else {
    //       _errors['user'] = err;
    //     }
    //   });
    // });
  }

  final Map _errors = {};

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

  @override
  Widget build(BuildContext context) {
    var res = _focusNodes.firstWhere((e) => !e['valid'],
        orElse: () => ({'missing': true}));
    setState(() {
      if (res['missing'] != null && res['missing']) {
        _validForm = true;
      } else {
        _validForm = false;
      }
    });
    _focusNodes.forEach((f) {
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
      body: AuthLayout(
        focusNodes: _focusNodes.map((e) => e['focus'] as FocusNode).toList(),
        photo: _auth == null
            ? null
            : _auth['photo'] == null || _auth['photo'].isEmpty
                ? 'https://res.cloudinary.com/echeckout/image/upload/v1672451195/assets/picture_bieyjd.png'
                : _auth['photo'],
        title: _auth != null ? 'Welcome Back!' : 'Login',
        desc: _auth != null
            ? 'Securely login to your account to continue'
            : 'Welcome! Login to your Pavypay account',
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_auth == null)
                FormGroup(
                  focusNode: _focusNodes[0]['focus'],
                  label: 'Email/Username',
                  onChanged: (val) {
                    _data['user'] = val?.trim();
                    _focusNodes[0]['valid'] = _validate('user');
                  },
                  onSubmit: (val) {
                    _focusNodes[1]['focus'].requestFocus();
                  },
                  errMsg: _errors['user'],
                ),
              FormGroup(
                focusNode: _focusNodes[1]['focus'],
                label: 'Password',
                onChanged: (val) {
                  _data['password'] = val;
                  _focusNodes[1]['valid'] = _validate('password');
                },
                onSubmit: (val) {},
                errMsg: _errors['password'],
                isPassword: _passField,
                mb: 5,
                toggler: IconButton(
                  onPressed: () {
                    setState(() {
                      _passField = !_passField;
                    });
                  },
                  icon: Icon(
                    _passField ? CustomIcons.eye_6 : CustomIcons.eye_slash_1,
                    size: _passField ? 13 : 16,
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  ),
                ),
                onPressed: () => NavigationController.slideBothSideways(
                  context,
                  const ForgotPasswordScreen(),
                  showNav: false,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secCol,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Button(
                type: 'primBtn',
                tapFunc: _submit,
                text: 'Login',
                loading: _submitting,
                disabled: !_validForm,
              ),
              const SizedBox(height: 25),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: _auth == null
                      ? () => NavigationController.slideBothSideways(
                            context,
                            const RegisterScreen(),
                          )
                      : () {
                          setState(() {
                            _auth = null;
                          });
                          // NotificationService().resetNotifs();
                          AuthService().logout();
                        },
                  child: Text(
                    _auth != null
                        ? 'Signin another account'
                        : 'New to Pavypay? Signup now',
                    style: const TextStyle(
                      color: AppTheme.primCol,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
