import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/outlet/outlet_provider.dart';
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
        onPressed: Scaffold.of(context).openDrawer,
        icon: const Center(child: Icon(Icons.menu_rounded, size: 32, weight: 1)),
      ),
      title: _Title(router),
      actions: switch (router) {
        IkkiRouter.pos => [
          const HomeCreateOrderButton(),
          const SizedBox(width: 8),
        ],
        _ => [],
      },
    );
  }
}

class _PosInfo extends ConsumerWidget {
  const _PosInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider).requireValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          outlet.name,
          style: textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontSize: 16,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
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
    final textTheme = Theme.of(context).textTheme;
    const color = Color.fromARGB(255, 24, 255, 182);
    return Row(
      children: [
        const Icon(Icons.wifi_rounded, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          'Online',
          style: textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _ShiftInfo extends ConsumerWidget {
  const _ShiftInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    const color = Color.fromARGB(255, 24, 255, 182);

    return Row(
      children: [
        const Icon(Icons.schedule_rounded, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          'Open',
          style: textTheme.bodySmall?.copyWith(color: Colors.white),
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
    return switch (router) {
      IkkiRouter.pos => const _PosInfo(),
      IkkiRouter.sales => const Text('Riwayat Penjualan'),
      IkkiRouter.shift => const Text('Pengelolaan Shift'),
      IkkiRouter.settings => const Text('Pengaturan'),
      _ => const Text('Ikki Pos'),
    };
  }
}
