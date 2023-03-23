import 'package:echeckout/icons/custom_icons_icons.dart';
import 'package:echeckout/local_data/geo_locations.dart';
import 'package:echeckout/screens/auth/login_screen.dart';
import 'package:echeckout/widgets/auth_layout.dart';
import 'package:echeckout/widgets/country_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_service.dart';
import '../../services/navigation_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/form_group.dart';
import '../../widgets/select_box.dart';
import 'verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String get restorationId => 'register';
  final Map<String, dynamic> _fields = {
    'first_name': {
      'field': 'first_name',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'First Name'
    },
    'last_name': {
      'field': 'last_name',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Last Name'
    },
    'email': {
      'field': 'email',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Email'
    },
    'phone': {
      'field': 'phone',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Phone Number'
    },
    'dob': {
      'field': 'dob',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Date of Birth'
    },
    'gender': {
      'field': 'gender',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Gender'
    },
    'username': {
      'field': 'username',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Create Username'
    },
    // 'country': {
    //   'field': 'country',
    //   'focus': FocusNode(),
    //   'touched': false,
    //   'valid': false,
    //   'label': 'Country'
    // },
    'password': {
      'field': 'password',
      'focus': FocusNode(),
      'touched': false,
      'valid': false,
      'label': 'Password'
    },
  };

  final _errors = {};
  final Map _data = {'country': 'Nigeria', 'type': 'personal'};
  bool _validForm = false;
  bool _submitting = false;

  final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
  bool _passField = true;

  Map ctryObj = {'name': 'Nigeria', 'code2': 'NG'};
  final TextEditingController _dateEditCtrl = TextEditingController();
  final TextEditingController _genderCtrl = TextEditingController();

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: (selected) {
      if (selected == null) return;
      setState(() {
        _data['dob'] = selected.toIso8601String().split('T')[0];
        _dateEditCtrl.text =
            '${selected.day}/${selected.month}/${selected.year}';
        _errors['dob'] = '';
      });
    },
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primCol,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primCol,
              ),
            ),
          ),
          child: DatePickerDialog(
            restorationId: 'date_picker_dialog',
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
            firstDate: DateTime(1914),
            lastDate: DateTime(2022),
          ),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  bool _validate(field, {String pattern = '', errMsg = ''}) {
    if (_data[field] == null || _data[field].isEmpty) {
      print('${_data[field]} validate');
      setState(() {
        _errors[field] = 'This field is required!';
      });
      return false;
    } else if (pattern.isNotEmpty) {
      var match =
          RegExp(r'' + pattern, caseSensitive: false).firstMatch(_data[field]);
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

  void _submit() {
    setState(() {
      _submitting = true;
    });
    AuthService().signup(_data).then((value) {
      _formKey.currentState!.reset();
      setState(() {
        _submitting = false;
      });
      NavigationController.slideBothSideways(
        context,
        const VerifyEmailScreen(),
        showNav: false,
      );
    }).catchError((err) {
      setState(() {
        _submitting = false;
        if (err.contains(RegExp(r'email', caseSensitive: false))) {
          _errors['email'] = err;
        } else {
          _errors['username'] = err;
        }
      });
    });
  }

  Map _selClose = {};
  String _curSel = '';

  void _openUrl(url) async {
    var pUrl = Uri.parse(url);
    if (await canLaunchUrl(pUrl)) {
      await launchUrl(pUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    var res =
        _fields.keys.firstWhere((k) => !_fields[k]['valid'], orElse: () => '');
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
            v['touched'] = true;
          } else if (!v['focus'].hasFocus && v['touched']) {
            if (k == 'email') {
              v['valid'] = _validate(
                k,
                pattern:
                    "^[a-z\\d.!#\$%&'*+/=?^_`{|}~-]+@[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?(?:\\.[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?)*\$",
                errMsg: 'Enter a valid email!',
              );
            } else if (k == 'username') {
              v['valid'] = _validate(
                k,
                pattern: "^[a-z\\d]+\$",
                errMsg: 'Username cannot contain special characters!',
              );
            } else if (k == 'password') {
              v['valid'] = _validate(
                k,
                pattern: "[^a-z\\d]+",
                errMsg: 'Password must contain at least one special character!',
              );
            } else {
              v['valid'] = _validate(k);
            }
          }
          setState(() {});
        });
      }
    });
    return Scaffold(
      key: _scaffKey,
      body: AuthLayout(
        title: 'Create Account',
        desc:
            'Create a free account and start buying anything safely online with Pavypay ',
        focusNodes: _fields.values.map((e) => e['focus'] as FocusNode).toList(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              FormGroup(
                focusNode: _fields['first_name']['focus'],
                label: _fields['first_name']['label'],
                onChanged: (val) {
                  _data['first_name'] = val?.trim();
                  _fields['first_name']['valid'] = _validate('first_name');
                },
                onSubmit: (val) {
                  _fields['last_name']['focus'].requestFocus();
                },
                errMsg: _errors['first_name'],
              ),
              FormGroup(
                focusNode: _fields['last_name']['focus'],
                label: _fields['last_name']['label'],
                onChanged: (val) {
                  _data['last_name'] = val?.trim();
                  _fields['last_name']['valid'] = _validate('last_name');
                },
                onSubmit: (val) {
                  _fields['email']['focus'].requestFocus();
                },
                errMsg: _errors['last_name'],
              ),
              FormGroup(
                focusNode: _fields['email']['focus'],
                label: _fields['email']['label'],
                onChanged: (val) {
                  _data['email'] = val?.trim();
                  _fields['email']['valid'] = _validate(
                    'email',
                    pattern:
                        "^[a-z\\d.!#\$%&'*+/=?^_`{|}~-]+@[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?(?:\\.[a-z\\d](?:[a-z\\d-]{0,61}[a-z\\d])?)*\$",
                    errMsg: 'Enter a valid email!',
                  );
                },
                onSubmit: (val) {
                  _fields['phone']['focus'].requestFocus();
                },
                errMsg: _errors['email'],
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  FormGroup(
                    focusNode: _fields['phone']['focus'],
                    label: _fields['phone']['label'],
                    onChanged: (val) {
                      _data['phone'] = val == null || val.isEmpty
                          ? ''
                          : '+234${int.parse(val.trim())}';
                      _fields['phone']['valid'] = _validate('phone');
                    },
                    keybType: TextInputType.phone,
                    padding: const EdgeInsets.only(left: 100, right: 19),
                    onSubmit: (val) {
                      _fields['dob']['focus'].requestFocus();
                    },
                    errMsg: _errors['phone'],
                  ),
                  Positioned(
                    top: 0,
                    left: 19,
                    height: 55,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Color(0xFFA2AFC6),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            CountryIcons(
                              code: ctryObj['code2'].toLowerCase(),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.keyboard_arrow_down_sharp)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FormGroup(
                focusNode: _fields['dob']['focus'],
                label: _fields['dob']['label'],
                onChanged: (val) {
                  // _data['dob'] = val;
                  _fields['dob']['valid'] = _validate('dob');
                },
                keybType: TextInputType.datetime,
                hint: 'DD/MM/YYYY',
                readonly: true,
                onTap: () => _restorableDatePickerRouteFuture.present(),
                onSubmit: (val) {
                  _fields['gender']['focus'].requestFocus();
                },
                controller: _dateEditCtrl,
                errMsg: _errors['dob'],
              ),
              SelectBox(
                focusNode: _fields['gender']['focus'],
                label: _fields['gender']['label'],
                options: const [
                  {'val': 'Male', 'txt': 'Male'},
                  {'val': 'Female', 'txt': 'Female'},
                ],
                hint: 'Select',
                onSelect: (val) {
                  _data['gender'] = val['val'];
                  _fields['gender']['valid'] = _validate(
                    'gender',
                  );
                },
                onTap: (closeF) {
                  if (_curSel.isNotEmpty) {
                    _selClose[_curSel]();
                  }
                  _selClose['gender'] = closeF;
                  _curSel = 'gender';
                },
                onClose: () {
                  _curSel = '';
                },
                errMsg: _errors['gender'],
              ),
              // SelectBox(
              //   focusNode: _fields['country']['focus'],
              //   label: _fields['country']['label'],
              //   options: GeoLocations.countriesStates
              //       .map((c) => {'val': c['name'], 'txt': c['name']})
              //       .toList(),
              //   hint: 'Select',
              //   onSelect: (val) {
              //     _data['country'] = val['val'];
              //     _fields['country']['valid'] = _validate(
              //       'country',
              //     );
              //   },
              //   onTap: (closeF) {
              //     if (_curSel.isNotEmpty) {
              //       _selClose[_curSel]();
              //     }
              //     _selClose['country'] = closeF;
              //     _curSel = 'country';
              //   },
              //   search: true,
              //   onClose: () {
              //     _curSel = '';
              //   },
              //   errMsg: _errors['country'],
              // ),
              FormGroup(
                focusNode: _fields['username']['focus'],
                label: _fields['username']['label'],
                onChanged: (val) {
                  _data['username'] = val?.trim();
                  _fields['username']['valid'] = _validate(
                    'username',
                    pattern: "^[a-z\\d]+\$",
                    errMsg: 'Username cannot contain special characters!',
                  );
                },
                onSubmit: (val) {
                  _fields['password']['focus'].requestFocus();
                },
                errMsg: _errors['username'],
              ),
              FormGroup(
                focusNode: _fields['password']['focus'],
                label: 'Password',
                onChanged: (val) {
                  _data['password'] = val;
                  _fields['password']['valid'] = _validate(
                    'password',
                    pattern: "[^a-z\\d]+",
                    errMsg:
                        'Password must contain at least one special character!',
                  );
                },
                onSubmit: (val) {},
                errMsg: _errors['password'],
                isPassword: _passField,
                mb: 20,
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
              const SizedBox(height: 40),
              Button(
                type: 'primBtn',
                tapFunc: _submit,
                text: 'Sign Up',
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
                    'Already a member? Login',
                    style: TextStyle(
                      color: AppTheme.primCol,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 73),
              Container(
                alignment: Alignment.center,
                child: Text.rich(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'By clicking "Sign Up" you agree to Pavypay\'s\n',
                    style: const TextStyle(
                        color: Color(0xFF788190), fontSize: 13, height: 1.6),
                    children: [
                      TextSpan(
                        text: 'Terms of Use',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openUrl(
                                'https://pavypay.com/legal/terms-of-service');
                          },
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openUrl(
                                'https://pavypay.com/legal/privacy-policy');
                          },
                      ),
                    ],
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

class GenderModal extends StatelessWidget {
  const GenderModal({
    super.key,
    this.selected,
  });
  final String? selected;

  GestureDetector _cusTile(ctx, val) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(ctx).pop(val);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 13, 22, 13),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: selected != val
                      ? Theme.of(ctx).primaryColorDark
                      : Theme.of(ctx).primaryColor,
                ),
              ),
              alignment: Alignment.center,
              width: 18,
              height: 18,
              child: selected != val
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(ctx).primaryColor,
                      ),
                      width: 11,
                      height: 11,
                    ),
            ),
            const SizedBox(width: 10),
            Text(val),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        margin: const EdgeInsets.all(11),
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cusTile(context, 'Male'),
            _cusTile(context, 'Female'),
          ],
        ));
  }
}
