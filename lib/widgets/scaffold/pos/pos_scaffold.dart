import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pos_app_bar.dart';
import 'pos_app_drawer.dart';

class PosScaffold extends ConsumerWidget {
  const PosScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const PosAppBar(),
        drawer: const PosAppDrawer(),
        body: child,
      ),
    );
  }
}
