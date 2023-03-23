import 'package:flutter/material.dart';

import '../../widgets/user_layout.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserLayout(
        pageTitle: 'My Cart',
        activePage: 'cart',
        showNav: true,
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
