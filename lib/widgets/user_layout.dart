import 'package:echeckout/icons/custom_icons_icons.dart';
import 'package:echeckout/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class UserLayout extends StatelessWidget {
  const UserLayout({
    super.key,
    this.pageTitle,
    this.activePage,
    required this.body,
    this.padH = 15,
    this.rightAct,
    this.showNav = false,
    this.physics,
    this.headBd = false,
    this.backFunc,
    this.controller,
    this.focusNodes,
    this.onTap,
    this.fg,
  });
  final String? pageTitle;
  final Widget body;
  final String? activePage;
  final double padH;
  final Widget? rightAct;
  final bool showNav;
  final ScrollPhysics? physics;
  final bool headBd;
  final VoidCallback? backFunc;
  final ScrollController? controller;
  final List<FocusNode>? focusNodes;
  final VoidCallback? onTap;
  final Color? fg;

  _rightCol(ctx, slug) {
    return activePage == slug
        ? Theme.of(ctx).primaryColor
        : const Color(0xFFA0A9B1);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (focusNodes != null) {
          for (var f in focusNodes as List) {
            f.unfocus();
          }
        }
        if (onTap != null) {
          onTap!();
        }
      },
      child: SizedBox(
        height: mq.size.height,
        width: mq.size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (pageTitle != null)
              Container(
                padding: EdgeInsets.fromLTRB(
                  0,
                  mq.padding.top + 15 + 21,
                  0,
                  21,
                ),
                decoration: !headBd
                    ? null
                    : const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE6E8EB),
                          ),
                        ),
                      ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: backFunc ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 40,
                        alignment: Alignment.centerLeft,
                        width: 50,
                        child: const Icon(
                          CustomIcons.arrow_back,
                          size: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        pageTitle as String,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      width: 50,
                      alignment: Alignment.centerRight,
                      child: rightAct as Widget,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    height: mq.size.height -
                        (showNav ? 67 : 0) -
                        (pageTitle != null
                            ? rightAct != null
                                ? 167
                                : 145
                            : 0),
                    child: SingleChildScrollView(
                      physics: physics,
                      controller: controller,
                      padding: EdgeInsets.symmetric(horizontal: padH),
                      child: body,
                    ),
                  ),
                  if (showNav) BottomNav(activePage: activePage)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
