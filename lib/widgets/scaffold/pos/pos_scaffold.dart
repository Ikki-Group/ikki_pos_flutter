import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/ikki_router.dart';
import 'pos_app_bar.dart';
import 'pos_app_drawer.dart';

class PosScaffold extends ConsumerWidget {
  const PosScaffold({required this.child, this.router, super.key});

  final Widget child;
  final IkkiRouter? router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PosAppBar(router: router),
        drawer: const PosAppDrawer(),
        body: child,
      ),
    );
  }
}
