import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';
import '../../data/user/user.model.dart';
import '../ui/pos_button.dart';
import '../ui/pos_dialog.dart';

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
    return PosDialog(
      title: 'Pilih Kasir',
      scrollable: false,
      constraints: const BoxConstraints(maxWidth: 500),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: PosButton.cancel(onPressed: _onClose)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: PosButton.process(onPressed: value == null ? null : _onConfirm),
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
        Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              final user = widget.users[index];
              final isSelected = value?.id == user.id;

              return CheckboxListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                value: isSelected,
                contentPadding: EdgeInsets.zero,
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
      ],
      // child: Container(
      //   width: MediaQuery.of(context).size.width * 0.9,
      //   constraints: const BoxConstraints(maxWidth: 500),
      //   clipBehavior: Clip.antiAlias,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(16),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withValues(alpha: .2),
      //         blurRadius: 20,
      //         offset: const Offset(0, 8),
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       // Header
      //       Container(
      //         padding: const EdgeInsets.all(16),
      //         child: const Row(
      //           children: [
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Pilih Karyawan',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.w600,
      //                     ),
      //                   ),
      //                   SizedBox(height: 4),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 8),

      //       Container(
      //         padding: const EdgeInsets.all(16),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: OutlinedButton(
      //                 onPressed: _onClose,
      //                 child: const Text('Cancel'),
      //               ),
      //             ),
      //             const SizedBox(width: 12),
      //             Expanded(
      //               flex: 2,
      //               child: ElevatedButton(
      //                 onPressed: value == null ? null : _onConfirm,
      //                 child: const Text('Pilih'),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
