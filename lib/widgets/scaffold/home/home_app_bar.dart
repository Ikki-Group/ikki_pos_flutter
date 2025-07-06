import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/features/home/widgets/home_create_order_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: IconButton(
        onPressed: Scaffold.of(context).openDrawer,
        icon: Center(
          child: Icon(
            Icons.menu_rounded,
            size: 32,
            weight: 1,
          ),
        ),
      ),

      title: _LeftInfo(),
      actions: [HomeCreateOrderButton()],
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }
}

class _LeftInfo extends ConsumerWidget {
  const _LeftInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletNotifierProvider.select((s) => s.requiredOutlet));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: <Widget>[
        Text(
          outlet.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_NetInfoWidget(), SizedBox(width: 8), _ShiftInfoWidget()],
        ),
      ],
    );
  }
}

class _NetInfoWidget extends ConsumerWidget {
  const _NetInfoWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Icon(Icons.network_cell, color: Colors.white70, size: 10),
        SizedBox(width: 8),
        Text(
          "Online",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ShiftInfoWidget extends ConsumerWidget {
  const _ShiftInfoWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletNotifierProvider);
    final isOpen = outlet.isOpen();

    final Color? color = isOpen ? Colors.greenAccent[400] : Colors.redAccent[200];

    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 10),
        SizedBox(width: 8),
        Text(
          isOpen ? "Shift Open" : "Shift Closed",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
