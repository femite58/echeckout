import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../services/navigation_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/user_layout.dart';

class ScanProduct extends StatefulWidget {
  static const routeName = '/cart';
  const ScanProduct({super.key});

  @override
  State<ScanProduct> createState() => _ScanProductState();
}

class _ScanProductState extends State<ScanProduct> with TickerProviderStateMixin {
  final MobileScannerController _ctrl = MobileScannerController();
  late AnimationController _animCtrl;
  late Animation<double> _pos;

  @override
  void initState() {
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pos = Tween<double>(begin: 0, end: 247).animate(CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.linear,
    ));
    _animCtrl.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  final BorderSide _border = const BorderSide(
    color: AppTheme.primCol,
    width: 3,
  );

  _eachConner({l = false, t = false, r = false, b = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: !l ? BorderSide.none : _border,
          top: !t ? BorderSide.none : _border,
          right: !r ? BorderSide.none : _border,
          bottom: !b ? BorderSide.none : _border,
        ),
      ),
      width: 22,
      height: 22,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: UserLayout(
          pageTitle: 'Scan QR Code',
          fg: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (_, __) {
                      return Stack(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: MobileScanner(
                              controller: _ctrl,
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                for (var code in barcodes) {
                                  // NavigationController.replace(
                                  //   context,
                                  //   ScanToPayScreen(code.rawValue),
                                  // );
                                  break;
                                }
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: _eachConner(l: true, t: true),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _eachConner(r: true, t: true),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: _eachConner(l: true, b: true),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: _eachConner(r: true, b: true),
                          ),
                          Positioned(
                            top: _pos.value,
                            width: 250,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: _border,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
              const SizedBox(height: 70),
              Text.rich(
                TextSpan(
                  text: 'if no QR Code ',
                  children: [
                    TextSpan(
                      text: 'Click here',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).pop(),
                      style: const TextStyle(
                        color: AppTheme.primCol,
                      ),
                    ),
                    const TextSpan(text: ' to \nfind nearby merchant')
                  ],
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _ctrl.toggleTorch();
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    const Text(
                      'Tap to turn on',
                      style: TextStyle(
                        color: Color(0xFF919191),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      child: Image.asset('assets/Images/flashlight.png'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
