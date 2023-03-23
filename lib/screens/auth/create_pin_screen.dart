import 'package:echeckout/screens/user/dashboard_screen.dart';
import 'package:echeckout/services/navigation_controller.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/buttons.dart';

class CreatePinScreen extends StatefulWidget {
  static const String routeName = '/create-pin';
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  Map _data = {};
  bool _validForm = false;

  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List _pin = ['', '', '', ''];
  bool _submitting = false;

  _validate() {
    setState(() {
      if (_data['pin'].length != 4) {
        _validForm = false;
      } else {
        _validForm = true;
      }
    });
  }

  Expanded _pinField(i, onChange) {
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        focusNode: _focusNodes[i],
        style: const TextStyle(
          color: AppTheme.secCol,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
          fillColor: _focusNodes[i].hasFocus
              ? const Color(0xFFECF4FF)
              : const Color(0xFFFAFAFA),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: AppTheme.primCol,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Color(0xFFE5E5E5),
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (val) {
          onChange(val);
          _pin[i] = val;
          _data['pin'] = _pin.join('');
          _validate();
        },
      ),
    );
  }

  _submit() {
    setState(() {
      _submitting = true;
    });
    AuthService().submitPIN(_data).then((res) {
      setState(() {
        _submitting = false;
      });
      NavigationController.replaceNav(
        context,
        const DashboardScreen(),
        DashboardScreen.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLayout(
        title: 'Create PIN',
        desc: 'Create a 4 digit transaction PIN to secure your account',
        focusNodes: _focusNodes,
        body: Column(
          children: [
            Row(
              children: [
                _pinField(0, (val) {
                  if (val.isNotEmpty) _focusNodes[1].requestFocus();
                }),
                const SizedBox(width: 15),
                _pinField(1, (val) {
                  if (val.isNotEmpty) _focusNodes[2].requestFocus();
                }),
                const SizedBox(width: 15),
                _pinField(2, (val) {
                  if (val.isNotEmpty) _focusNodes[3].requestFocus();
                }),
                const SizedBox(width: 15),
                _pinField(3, (val) {
                  if (val.length < _data['pin'].length) {}
                }),
              ],
            ),
            const SizedBox(height: 61),
            Button(
              type: 'primBtn',
              tapFunc: _submit,
              text: 'Create PIN',
              loading: _submitting,
              disabled: !_validForm,
            ),
          ],
        ),
      ),
    );
  }
}
