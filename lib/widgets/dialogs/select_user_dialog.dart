import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';
import '../../data/user/user.model.dart';

class SelectUserDialog extends StatefulWidget {
  const SelectUserDialog({required this.users, this.initialValue, super.key});

  final List<UserModel> users;
  final UserModel? initialValue;

  @override
  State<SelectUserDialog> createState() => _SelectUserDialogState();

  static Future<UserModel?> show(
    BuildContext context, {
    required List<UserModel> users,
    UserModel? initialValue,
  }) {
    return showDialog<UserModel?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SelectUserDialog(
          users: users,
          initialValue: initialValue,
        );
      },
    );
  }
}

class _SelectUserDialogState extends State<SelectUserDialog> {
  late ScrollController _scrollController;
  UserModel? value;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    value = widget.initialValue;

    final scrollIndex = widget.initialValue != null
        ? widget.users.indexWhere((user) => user.id == widget.initialValue!.id)
        : -1;

    if (scrollIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollTo(scrollIndex);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    Navigator.of(context).pop(value);
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
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Karyawan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                'Daftar Karyawan',
                style: context.textTheme.labelLarge,
                textAlign: TextAlign.left,
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                controller: _scrollController,
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  final user = widget.users[index];
                  final isSelected = value?.id == user.id;

                  return CheckboxListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    value: isSelected,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    checkboxScaleFactor: 1.2,
                    selectedTileColor: POSTheme.primaryBlue,
                    onChanged: (bool? newValue) {
                      value = user;
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onClose,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: value == null ? null : _onConfirm,
                      child: const Text('Pilih'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
