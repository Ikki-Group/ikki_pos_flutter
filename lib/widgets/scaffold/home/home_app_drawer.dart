import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/data/user/user_notifier.dart';
import 'package:ikki_pos_flutter/router/ikki_router.dart';

enum SGDrawerItem {
  home(name: 'Mulai Penjualan', icon: Icons.point_of_sale, path: "/home"),
  sales(name: 'Riwayat Penjualan', icon: Icons.history, path: "/history"),
  finance(name: 'Laporan Keuangan', icon: Icons.attach_money, path: "/finance"),
  shift(name: 'Pengelolaan Shift', icon: Icons.access_time, path: "/shift"),
  input(name: 'Input Pembukuan', icon: Icons.attach_money, path: "/input"),
  printers(name: 'Printer', icon: Icons.print, path: "/printers"),
  settings(name: 'Pengaturan', icon: Icons.settings, path: "/settings");

  const SGDrawerItem({
    required this.name,
    required this.icon,
    required this.path,
  });

  final String name;
  final IconData icon;
  final String path;
}

class HomeAppDrawer extends StatelessWidget {
  const HomeAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).fullPath;

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [BoxShadow()],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 8.0), _UserInfo()],
              ),
            ),
          ),

          // Menu Items Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              children: [
                for (var item in SGDrawerItem.values)
                  _buildMenuItem(
                    context,
                    item: item,
                    index: item.index,
                    isSelected: item.path == location,
                    onTap: () {
                      context.go(item.path);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required bool isSelected,
    required Function() onTap,
    required SGDrawerItem item,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.transparent,
          border: Border(
            right: BorderSide(
              color: isSelected ? Colors.orangeAccent : Colors.transparent,
              width: 5.0,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(
            item.icon,
            color: isSelected ? Colors.blue : Colors.grey[600],
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.blue : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInfo extends ConsumerWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF003366)),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  user.id,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.go(IkkiRouter.userSelect.path);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
          ),
          child: Icon(
            Icons.logout,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
