import 'package:flutter/material.dart';

import '../../widgets/user_layout.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserLayout(
        showNav: true,
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
