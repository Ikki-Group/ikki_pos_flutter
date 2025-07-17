import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet.provider.dart';
import '../../../features/home/widgets/home_create_order_button.dart';

class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PosAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

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
    final textStyle = context.textStyle;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          outlet.name,
          style: textStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Text(
              'Online',
              style: textStyle.copyWith(
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Online',
              style: textStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
      // const _ShiftInfoWidget(),
    );
  }
}
