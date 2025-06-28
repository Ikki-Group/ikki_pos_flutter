import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/data/user/user_model.dart';
import 'package:ikki_pos_flutter/features/user/widgets/user_select_dialog.dart';

class UserSelectPage extends ConsumerStatefulWidget {
  const UserSelectPage({super.key});

  @override
  ConsumerState<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends ConsumerState<UserSelectPage> {
  User? selectedUser;

  _openDialog() async {
    final user = await showDialog<User?>(
      context: context,
      builder: (context) => UserSelectDialog(
        initialValue: selectedUser,
      ),
    );

    if (user == null) return;

    setState(() {
      selectedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletNotifierProvider).outlet!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang Kembali',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '-- IKKI Coffee --',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromWidth(280),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                _openDialog();
              },
              child: Row(
                children: [
                  const Icon(Icons.person, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedUser?.name ?? 'Pilih Karyawan',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 280,
              child: AspectRatio(aspectRatio: 1 / 1, child: Placeholder()),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(height: 100, child: Center(child: Text(text))),
    );
  }
}
