import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _HomeAppBar(), drawer: _HomeDrawer(), body: child);
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: IconButton(
        onPressed: Scaffold.of(context).openDrawer,
        icon: Center(child: Icon(Icons.menu_rounded)),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          const Text(
            'Ikki Coffee',
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
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

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
                children: [
                  const SizedBox(height: 8.0),
                  // User Info
                  Row(
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
                            children: const [
                              Text(
                                'ikki',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'haha resto',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle ADMIN POS button tap
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'ADMIN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                    icon: item.icon,
                    title: item.name,
                    index: item.index,
                    isSelected: "/" == location,
                    onTap: (idx) {
                      context.goNamed("/placeholder");
                    },
                  ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    required Function(int) onTap,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      // onTap: () => {
      //   SGDrawerItem.finance,
      //   context.goNamed("/placeholder"),
      //   // close drawer
      //   Navigator.pop(context),
      // },
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
            icon,
            color: isSelected ? Colors.blue : Colors.grey[600],
          ),
          title: Text(
            title,
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

enum SGDrawerItem {
  home(name: 'Mulai Penjualan', icon: Icons.point_of_sale),
  sales(name: 'Riwayat Penjualan', icon: Icons.history),
  finance(name: 'Laporan Keuangan', icon: Icons.attach_money),
  shift(name: 'Pengelolaan Shift', icon: Icons.access_time),
  input(name: 'Input Pembukuan', icon: Icons.attach_money),
  printers(name: 'Printer', icon: Icons.print),
  settings(name: 'Pengaturan', icon: Icons.settings);

  const SGDrawerItem({required this.name, required this.icon});

  final String name;
  final IconData icon;
}
