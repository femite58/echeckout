import 'package:flutter/material.dart';

import '../../widgets/user_layout.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore';
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserLayout(
        pageTitle: 'Find Products',
        activePage: 'explore',
        showNav: true,
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
