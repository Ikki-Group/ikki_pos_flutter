import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/user/user.model.dart';
import '../../../widgets/ui/button_variants.dart';
import '../../../widgets/ui/ikki_dialog.dart';

class UserSelectDialog extends ConsumerStatefulWidget {
  const UserSelectDialog({required this.users, super.key, this.initialValue});

  final UserModel? initialValue;
  final List<UserModel> users;

  @override
  ConsumerState createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends ConsumerState<UserSelectDialog> {
  late ScrollController _scrollController;
  late List<UserModel> _users;
  UserModel? _selectedUser;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedUser = widget.initialValue;
    _users = widget.users;

    final scrollIndex = _selectedUser != null ? _users.indexWhere((user) => user.id == _selectedUser!.id) : 0;
    if (scrollIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollTo(scrollIndex);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(int index) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        index * 32.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IkkiDialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 450,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const IkkiDialogTitle(title: 'Pilih Karyawan'),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                controller: _scrollController,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final isSelected = _selectedUser?.id == user.id;

                  return CheckboxListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    value: isSelected,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    selectedTileColor: Colors.red,
                    activeColor: Colors.red,
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return POSTheme.primaryBlue;
                      }
                      return Colors.transparent;
                    }),
                    autofocus: true,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _selectedUser = user;
                      });
                    },
                  );
                },
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ThemedButton.cancel(
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(width: 8),
          ThemedButton.process(
            onPressed: _selectedUser == null ? null : () => Navigator.pop(context, _selectedUser),
          ),
        ],
      ),
    );
  }
}
