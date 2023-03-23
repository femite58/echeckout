import 'package:flutter/material.dart';

import '../../widgets/user_layout.dart';

class MoreScreen extends StatefulWidget {
  static const routeName = '/more';
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserLayout(
        pageTitle: 'More',
        activePage: 'more',
        showNav: true,
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
