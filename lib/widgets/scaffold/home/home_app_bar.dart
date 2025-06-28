import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_model.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

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
      actions: [_CreateOrderButton()],
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }
}

class _LeftInfo extends ConsumerWidget {
  const _LeftInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletNotifierProvider.select((s) => s.outlet))!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          outlet.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Icon(Icons.network_cell, color: Colors.white70, size: 10),
            Text("Online", style: TextStyle(fontSize: 14)),
            SizedBox(width: 8),
            Icon(Icons.circle, color: Colors.greenAccent[400], size: 10),
            Text("Shift Open", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

class _CreateOrderButton extends ConsumerWidget {
  const _CreateOrderButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () async {
        final outlet = ref.read(outletNotifierProvider);
        if (!outlet.isOpen()) {
          ref
              .read(outletNotifierProvider.notifier)
              .setOpen(
                OutletSessionOpen(
                  at: DateTime.now().toString(),
                  by: "ikki",
                  balance: 10000,
                  note: "Ikki Coffee",
                ),
              );

          // Open dialog
          final res = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Success"),
              content: const Text("Successfully opened the outlet"),
              actions: [
                // Simulate return value from dialog
                TextButton(
                  onPressed: () => Navigator.of(context).pop(1234324),
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );

          if (context.mounted) {
            // Show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Successfully opened the outlet ${res.toString()}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.greenAccent,
              ),
            );
          }
        }
      },
      icon: const Icon(
        Icons.add,
        size: 24,
      ),
      label: Text(
        'Tambah Pesanan',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
