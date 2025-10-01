import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/provider/user_provider.dart';
import '../../../model/user_model.dart';
import '../../../router/ikki_router.dart';

class ShellDrawer extends ConsumerWidget {
  const ShellDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathName = GoRouter.of(context).state.name;

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [BoxShadow()],
            ),
            child: const SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [SizedBox(height: 8), _UserInfo()],
              ),
            ),
          ),

          // Menu Items Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              children: [
                for (final item in SGDrawerItem.values)
                  _buildMenuItem(
                    context,
                    item: item,
                    index: item.index,
                    isSelected: item.route.name == pathName,
                    onTap: () {
                      context.goNamed(item.route.name);
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
    required void Function() onTap,
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
              width: 5,
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

class _UserInfo extends ConsumerStatefulWidget {
  const _UserInfo();

  @override
  ConsumerState<_UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends ConsumerState<_UserInfo> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider.select((s) => s.selectedUser));
  }

  void onLogout() {
    context.goNamed(IkkiRouter.userSelect.name);
    ref.read(userProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text('Kasir', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          TextButton(
            onPressed: onLogout,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              fixedSize: const Size.square(24),
              minimumSize: Size.zero,
            ),
            child: const Icon(Icons.logout, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}

enum SGDrawerItem {
  pos(name: 'Mulai Penjualan', icon: Icons.point_of_sale, route: IkkiRouter.pos),
  sales(name: 'Riwayat Penjualan', icon: Icons.history, route: IkkiRouter.sales),
  // finance(name: 'Laporan Keuangan', icon: Icons.attach_money, route: IkkiRouter.settings),
  shift(name: 'Pengelolaan Shift', icon: Icons.access_time, route: IkkiRouter.shift),
  settings(name: 'Pengaturan', icon: Icons.settings, route: IkkiRouter.settings);

  const SGDrawerItem({
    required this.name,
    required this.icon,
    required this.route,
  });

  final String name;
  final IconData icon;
  final IkkiRouter route;
}
