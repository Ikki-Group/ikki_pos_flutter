import 'package:flutter/material.dart';

import 'home_app_bar.dart';
import 'home_app_drawer.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const HomeAppBar(),
        drawer: const HomeAppDrawer(),
        body: child,
      ),
    );
  }
}
