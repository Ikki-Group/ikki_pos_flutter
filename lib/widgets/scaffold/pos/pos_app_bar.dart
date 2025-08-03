import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/outlet/outlet.provider.dart';
import '../../../features/home/widgets/home_create_order_button.dart';
import '../../../router/ikki_router.dart';

class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PosAppBar({required this.router, super.key});

  final IkkiRouter? router;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: IconButton(
        style: IconButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: Scaffold.of(context).openDrawer,
        icon: const Center(child: Icon(Icons.menu_rounded, size: 32, weight: 1)),
      ),
      title: _Title(router),
      actions: const [
        HomeCreateOrderButton(),
        SizedBox(width: 8),
      ],
    );
  }
}

class _PosInfo extends ConsumerWidget {
  const _PosInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletProvider).requireValue;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          outlet.name,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Row(
          children: <Widget>[
            _NetInfo(),
            SizedBox(width: 12),
            _ShiftInfo(),
          ],
        ),
      ],
      // const _ShiftInfoWidget(),
    );
  }
}

class _NetInfo extends ConsumerWidget {
  const _NetInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const color = Color.fromARGB(255, 24, 255, 182);
    return Row(
      children: [
        const Icon(Icons.wifi_rounded, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          'Online',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ShiftInfo extends ConsumerWidget {
  const _ShiftInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const color = Color.fromARGB(255, 24, 255, 182);

    return Row(
      children: [
        const Icon(Icons.schedule_rounded, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          'Open',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.router);

  final IkkiRouter? router;

  @override
  Widget build(BuildContext context) {
    switch (router) {
      case IkkiRouter.pos:
        return const _PosInfo();
      case IkkiRouter.cart:
        return const Text('Cart');
      case IkkiRouter.settings:
        return const Text('Pengaturan');
      // ignore: no_default_cases
      default:
        return const Text('IKKI Pos');
    }
  }
}
