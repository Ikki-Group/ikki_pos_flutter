import 'package:flutter/material.dart';
import 'package:ikki_pos_flutter/widgets/scaffold/home/home_app_bar.dart';
import 'package:ikki_pos_flutter/widgets/scaffold/home/home_app_drawer.dart';

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
        appBar: HomeAppBar(),
        drawer: HomeAppDrawer(),
        body: child,
      ),
    );
  }
}
