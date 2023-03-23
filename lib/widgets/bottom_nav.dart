import 'dart:async';

import 'package:echeckout/screens/user/cart_screen.dart';
import 'package:echeckout/screens/user/more_screen.dart';
import 'package:echeckout/screens/user/scan_product.dart';
import 'package:flutter/material.dart';

import '../icons/custom_icons_icons.dart';
import '../screens/user/explore_screen.dart';
import '../services/navigation_controller.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, this.activePage});
  final String? activePage;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  _rightCol(ctx, slug) {
    return widget.activePage == slug
        ? Theme.of(ctx).primaryColor
        : const Color(0xFFA0A9B1);
  }

  @override
  Widget build(BuildContext context) {
    var scSz = MediaQuery.of(context).size;
    var actPage = widget.activePage;
    return Positioned(
      bottom: 0,
      width: scSz.width,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 15.41),
              Container(
                height: 67,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x11000000),
                      offset: Offset.zero,
                      spreadRadius: 10,
                      blurRadius: 20,
                    ),
                  ],
                ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: actPage == 'home'
                            ? null
                            : () {
                                setState(() {
                                  NavigationController.activePage = 'home';
                                });
                                Navigator.of(context).popUntil(
                                  ModalRoute.withName('/dashboard'),
                                );
                              },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CustomIcons.home_2,
                              size: 21,
                              color: _rightCol(context, 'home'),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Home',
                              style: TextStyle(
                                color: _rightCol(context, 'home'),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: actPage == 'explore'
                            ? null
                            : () => NavigationController.noAnimNavig(
                                  context,
                                  const ExploreScreen(),
                                  settings:
                                      const RouteSettings(name: '/explore'),
                                ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CustomIcons.explore,
                              size: 21,
                              color: _rightCol(context, 'explore'),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Explore',
                              style: TextStyle(
                                color: _rightCol(context, 'explore'),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 71),
                    Expanded(
                      child: TextButton(
                        onPressed: actPage == 'cart'
                            ? null
                            : () {
                                NavigationController.noAnimNavig(
                                  context,
                                  const CartScreen(),
                                  settings: const RouteSettings(name: '/cart'),
                                );
                              },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CustomIcons.cart_1,
                              size: 21,
                              color: _rightCol(context, 'cart'),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Cart',
                              style: TextStyle(
                                color: _rightCol(context, 'cart'),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => NavigationController.noAnimNavig(
                          context,
                          const MoreScreen(),
                          settings: const RouteSettings(name: '/more'),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CustomIcons.more,
                              size: 21,
                              color: _rightCol(context, 'more'),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'More',
                              style: TextStyle(
                                color: _rightCol(context, 'more'),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: scSz.width / 2,
            child: FractionalTranslation(
              translation: const Offset(-0.5, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ScanProduct(),
                        opaque: false,
                        transitionDuration: const Duration(milliseconds: 400),
                        // reverseTransitionDuration:
                        //     const Duration(milliseconds: 450),
                        transitionsBuilder: (ctx, animation, _, child) {
                          var sz = MediaQuery.of(ctx).size;
                          var stween = Tween<double>(begin: 1, end: 32).chain(
                            CurveTween(curve: Curves.easeInSine),
                          );
                          var ctween = Tween<double>(begin: 1, end: 0);
                          var rtween =
                              Tween<double>(begin: 25.785, end: sz.height)
                                  .chain(
                            CurveTween(curve: Curves.easeInSine),
                          );
                          return Stack(
                            children: [
                              AnimatedBuilder(
                                animation: animation.drive(rtween),
                                builder: (_, __) => ClipPath(
                                  clipper: CircleClipper(
                                    radius: rtween.evaluate(animation),
                                    center: Offset(
                                      sz.width / 2,
                                      sz.height - 31 - 25.785,
                                    ),
                                  ),
                                  child: child,
                                ),
                              ),
                              Positioned(
                                bottom: 31,
                                left: MediaQuery.of(ctx).size.width / 2,
                                child: FractionalTranslation(
                                  translation: const Offset(-.5, 0),
                                  child: FadeTransition(
                                    opacity: animation.drive(ctween),
                                    child: ScaleTransition(
                                      scale: animation.drive(stween),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF1565D8),
                                          shape: BoxShape.circle,
                                        ),
                                        width: 51.57,
                                        height: 51.57,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  );
                  // var ms = MediaQuery.of(context).size;

                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (_) => const AddPage(),
                  //   backgroundColor: Colors.transparent,
                  //   barrierColor: Colors.transparent,
                  //   isScrollControlled: true,
                  //   constraints: BoxConstraints(
                  //     maxWidth: ms.width,
                  //     maxHeight: ms.height,
                  //   ),
                  //   transitionAnimationController: AnimationController(
                  //     vsync: this,
                  //     duration: Duration.zero,
                  //   ),
                  // );
                },
                child: Container(
                  width: 51.57,
                  height: 51.57,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primCol,
                  ),
                  child: const Icon(
                    CustomIcons.scan_code,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  CircleClipper({required this.radius, required this.center});
  final Offset center;
  final double radius;
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(radius: radius, center: center));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  Animation<Size>? _anim;
  late AnimationController _pctrl;
  late Animation<double> _panim;
  late AnimationController _bctrl;
  late Animation<double> _banim;
  late AnimationController _cctrl;
  late Animation<Color?> _canim;
  @override
  void initState() {
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _pctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _panim = Tween<double>(begin: 31, end: 0).animate(_pctrl);
    _pctrl.addListener(() {
      setState(() {});
    });
    _bctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _banim = Tween<double>(begin: 200, end: 0).animate(_bctrl);
    _bctrl.addListener(() {
      setState(() {});
    });
    _cctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _canim = ColorTween(
      begin: const Color(0xFF1565D8),
      end: const Color(0xFFFFFFFF),
    ).animate(_cctrl);
    _cctrl.addListener(() {
      setState(() {});
    });
    Timer.run(() {
      var ms = MediaQuery.of(context).size;
      _anim = Tween<Size>(
              begin: const Size(51.57, 51.57), end: Size(ms.width, ms.height))
          .animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Curves.easeOut,
        ),
      );
      _ctrl.addListener(() {
        setState(() {});
      });
      setState(() {});
      _ctrl.forward();
      _bctrl.forward();
      _pctrl.forward();
      _cctrl.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: _panim.value),
      child: _anim == null
          ? null
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_banim.value),
                color: _canim.value,
              ),
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.only(top: 20),
              width: _anim!.value.width,
              height: _anim!.value.height,
            ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
