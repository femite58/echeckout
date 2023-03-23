import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../services/navigation_controller.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _actInd = 0;
  late AnimationController _fadeCtrl;
  late Animation<double> _opacity;

  final List _fadeAnim = [];

  final List _slides = [
    {
      'banner': 'assets/images/onboarding1.png',
      'title': 'Escrow payment system made for you',
      'content':
          'Pavypay is an escrow system that can help you secure and protect your funds.'
    },
    {
      'banner': 'assets/images/onboarding2.png',
      'title': 'Buy anything safely from anywhere',
      'content':
          'Buy anything safely online with confidence, ptotect yourself from chargbacks or fraud.'
    },
  ];

  late Offset _pos;
  late Offset _curPos;
  dynamic _notifSub;

  @override
  void initState() {
    // GeneralSettingsService().getSettings();
    AuthService().autoLogin().then((auth) {
      if (auth != null) {
        NotificationService().getNotifs();
        NavigationController.noAnimNavig(
          context,
          const LoginScreen(),
        );
      }
    });
    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: NotificationService.onActionReceivedMethod,
    //   onNotificationCreatedMethod:
    //       NotificationService.onNotificationCreatedMethod,
    //   onNotificationDisplayedMethod:
    //       NotificationService.onNotificationDisplayedMethod,
    // );
    // _getNotifs();
    for (int i = 0; i < _slides.length; i++) {
      var animc = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _fadeAnim.add({
        'controller': animc,
        'tween': Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animc, curve: Curves.ease)
            ..addListener(() {
              setState(() {});
            }),
        )
      });
    }
    (_fadeAnim[0]['controller'] as AnimationController).forward();
    // BillService().getLContacts();
    super.initState();
  }

  _getNotifs() {
    _notifSub = NotificationService().notifications.stream.listen((notifs) {
      if (notifs == null) {
        NotificationService().getNotifs();
        return;
      }
    });
  }

  @override
  void dispose() {
    _notifSub.cancel();
    super.dispose();
  }

  void _slide(int n) {
    _actInd += n;
    _actInd = _actInd == _slides.length
        ? 0
        : _actInd < 0
            ? _slides.length - 1
            : _actInd;
    for (int i = 0; i < _slides.length; i++) {
      if (i == _actInd) {
        (_fadeAnim[i]['controller'] as AnimationController).forward();
      } else {
        (_fadeAnim[i]['controller'] as AnimationController).animateBack(0);
      }
    }
  }

  Column _eachSlide(image, title, content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          width: 305,
        ),
        // const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints.loose(
            const Size.fromWidth(305),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: BoxConstraints.loose(
            const Size.fromWidth(315),
          ),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(mainAxisSize: MainAxisSize.max, children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                if (_fadeAnim.isNotEmpty)
                  GestureDetector(
                    onHorizontalDragStart: (details) {
                      _pos = details.globalPosition;
                    },
                    onHorizontalDragUpdate: (det) {
                      _curPos = det.globalPosition;
                    },
                    onHorizontalDragEnd: (details) {
                      if (_curPos.dx > _pos.dx) {
                        _slide(-1);
                      } else {
                        _slide(1);
                      }
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: _fadeAnim[0]['tween'].value,
                          child: _eachSlide(
                            _slides[0]['banner'],
                            _slides[0]['title'],
                            _slides[0]['content'],
                          ),
                        ),
                        for (int i = 1; i < _slides.length; i++)
                          Positioned(
                            child: Opacity(
                              opacity: _fadeAnim[i]['tween'].value,
                              child: _eachSlide(
                                _slides[i]['banner'],
                                _slides[i]['title'],
                                _slides[i]['content'],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _slides.length; i++)
                      Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _actInd == i
                              ? AppTheme.primCol
                              : const Color(0xFFE2E5F6),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
          // const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              children: [
                Button(
                  type: 'primBtn',
                  tapFunc: () {
                    // NavigationController.slideSideways(
                    //     context, const LoginScreen());
                    NavigationController.slideBothSideways(
                      context,
                      const RegisterScreen(),
                      showNav: false,
                    );
                  },
                  text: 'Get Started',
                ),
                const SizedBox(height: 15),
                Button(
                  type: 'primBtnOutline',
                  tapFunc: () {
                    // _tagRead();
                    NavigationController.slideBothSideways(
                      context,
                      const LoginScreen(),
                      showNav: false,
                    );
                  },
                  text: 'Login to your account',
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
