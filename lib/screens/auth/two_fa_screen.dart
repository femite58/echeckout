import 'dart:async';

import 'package:echeckout/helpers/text_transform.dart';
import 'package:echeckout/icons/custom_icons_icons.dart';
import 'package:echeckout/screens/auth/create_pin_screen.dart';
import 'package:echeckout/screens/auth/forgot_password_screen.dart';
import 'package:echeckout/screens/auth/register_screen.dart';
import 'package:echeckout/screens/auth/verify_email_screen.dart';
import 'package:echeckout/screens/user/dashboard_screen.dart';
import 'package:echeckout/services/auth_service.dart';
import 'package:echeckout/services/navigation_controller.dart';
import 'package:echeckout/widgets/auth_layout.dart';
import 'package:echeckout/widgets/buttons.dart';
import 'package:echeckout/widgets/form_group.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class TwoFaScreen extends StatefulWidget {
  static const routeName = '/two-fa';
  const TwoFaScreen({super.key});

  @override
  State<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends State<TwoFaScreen> {
  final Map _fields = {
    'answer': {
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'tapped': false,
      'ctrl': TextEditingController(),
    },
  };
  bool _submitting = false;

  final Map _data = {};

  bool _validForm = false;
  bool _isPass = false;

  dynamic _auth;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _auth = AuthService().auth.stream.value;
    _data['id'] = _auth['id'];
    super.initState();
  }

  void _submit() {
    setState(() {
      _submitting = true;
    });
    AuthService().twoAuth(_data).then((value) {
      setState(() {
        _submitting = false;
      });
      if (value['pin'] == null || value['pin'].isEmpty) {
        NavigationController.replaceNav(
          context,
          const CreatePinScreen(),
          CreatePinScreen.routeName,
        );
      } else {
        NavigationController.replaceNav(
          context,
          const DashboardScreen(),
          DashboardScreen.routeName,
        );
      }
    }).catchError((err) {
      setState(() {
        _submitting = false;
        _errors['answer'] = err.toString();
      });
    });
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
    var res =
        _fields.keys.firstWhere((e) => !_fields[e]['valid'], orElse: () => '');
    setState(() {
      if (res.isEmpty) {
        _validForm = true;
      } else {
        _validForm = false;
      }
    });
    _fields.forEach((k, v) {
      if (!v['focus'].hasListeners) {
        v['focus'].addListener(() {
          if (v['focus'].hasFocus) {
            v['tapped'] = true;
          } else if (!v['focus'].hasFocus && v['tapped']) {
            v['touched'] = true;
            v['valid'] = _validate(
              k,
            );
          }
          setState(() {});
        });
      }
    });
    return Scaffold(
      body: AuthLayout(
        focusNodes:
            _fields.keys.map((k) => _fields[k]['focus'] as FocusNode).toList(),
        title: 'Two Factor Authentication',
        desc: 'You are required to answer your security question',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormGroup(
              focusNode: _fields['answer']['focus'],
              label: _auth['question'],
              controller: _fields['answer']['ctrl'],
              onChanged: (val) {
                _data['answer'] = val?.trim();
                _fields['answer']['valid'] = _validate('answer');
              },
              onSubmit: (val) {},
              errMsg: _errors['answer'],
              isPassword: _isPass,
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
              mb: 40,
            ),
            Button(
              type: 'primBtn',
              tapFunc: _submit,
              text: 'Submit',
              loading: _submitting,
              disabled: !_validForm,
            ),
            const SizedBox(height: 25),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Signin another account',
                  style: TextStyle(
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
    );
  }
}
