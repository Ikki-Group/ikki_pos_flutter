import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/outlet/outlet.provider.dart';
import '../../../features/home/widgets/home_create_order_button.dart';

class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PosAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: IconButton(
        onPressed: Scaffold.of(context).openDrawer,
        icon: const Center(
          child: Icon(
            Icons.menu_rounded,
            size: 32,
            weight: 1,
          ),
        ),
      ),
      title: const _PosInfo(),
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
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        const Row(
          children: [
            _NetInfo(),
            SizedBox(width: 8),
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
    return Row(
      children: [
        Text(
          'Online',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSecondary),
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
    return Row(
      children: [
        Text(
          'Open',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSecondary),
        ),
      ],
    );
  }
}
