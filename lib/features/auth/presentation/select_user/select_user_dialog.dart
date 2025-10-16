import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/ui/pos_button.dart';
import '../../../../widgets/ui/pos_dialog_two.dart';
import '../../model/user_model.dart';

class SelectUserDialog extends ConsumerStatefulWidget {
  const SelectUserDialog({required this.users, this.initialValue, super.key});

  final List<UserModel> users;
  final UserModel? initialValue;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectUserDialogState();

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

class _SelectUserDialogState extends ConsumerState<SelectUserDialog> {
  late ScrollController scrollController;
  UserModel? value;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    value = widget.initialValue;

    final scrollIndex = value != null ? widget.users.indexWhere((user) => user.id == value!.id) : -1;

    if (scrollIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollTo(scrollIndex);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void scrollTo(int index) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        index * 40.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void onClose() => Navigator.pop(context);

  void onConfirm() => Navigator.pop(context, value);

  @override
  Widget build(BuildContext context) {
    return PosDialogTwo(
      title: 'Pilih Kasir',
      footer: Row(
        children: [
          Expanded(child: PosButton.cancel(onPressed: onClose)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: PosButton.process(onPressed: value == null ? null : onConfirm),
          ),
        ],
      ),
      children: [
        Text(
          'Daftar Karyawan',
          style: context.textTheme.labelLarge,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            controller: scrollController,
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              final user = widget.users[index];
              final isSelected = value?.id == user.id;

              return CheckboxListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                value: isSelected,
                contentPadding: EdgeInsets.zero,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                checkboxScaleFactor: 1.2,
                selectedTileColor: AppTheme.primaryBlue,
                onChanged: (_) {
                  value = user;
                  setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
