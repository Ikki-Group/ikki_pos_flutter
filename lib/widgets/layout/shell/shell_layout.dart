import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/ikki_router.dart';
import 'shell_appbar.dart';
import 'shell_drawer.dart';

class ShellLayout extends ConsumerWidget {
  const ShellLayout({required this.child, this.router, super.key});

  final Widget child;
  final IkkiRouter? router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: ShellAppbar(router: router),
        drawer: const ShellDrawer(),
        resizeToAvoidBottomInset: false,
        body: child,
      ),
    );
  }
}
