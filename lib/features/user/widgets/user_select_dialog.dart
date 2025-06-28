import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/user/user_model.dart';
import 'package:ikki_pos_flutter/data/user/user_repo.dart';

class UserSelectDialog extends StatefulWidget {
  const UserSelectDialog({super.key, this.initialValue});

  final User? initialValue;

  @override
  State<UserSelectDialog> createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {
  final ScrollController _scrollController = ScrollController();
  User? _selectedUser;
  bool _hasScrolledToInitialUser = false;

  @override
  void initState() {
    super.initState();
    _selectedUser = widget.initialValue;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 450,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle("Pilih Karyawan"),
            Flexible(
              flex: 1,
              child: Consumer(
                builder: (context, ref, child) {
                  final users = ref.watch(userRepoProvider).list();

                  if (users.isEmpty) {
                    return const Center(child: Text("No users available."));
                  }

                  if (!_hasScrolledToInitialUser && widget.initialValue != null) {
                    final index = users.indexWhere((user) => user.id == widget.initialValue!.id);

                    if (index != -1) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            index * 60.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                          _hasScrolledToInitialUser = true; // Set flag to prevent future scrolls
                        }
                      });
                    }
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: users.length,
                    itemExtent: 60,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isSelected = _selectedUser?.id == user.id;

                      return CheckboxListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        value: isSelected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _selectedUser = user;
                          });
                        },
                      );
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

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.blueAccent,
        shadowColor: Colors.red,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8), // Spacing between buttons
          ElevatedButton(
            // Disable button if no users are selected
            onPressed: _selectedUser == null
                ? null
                : () {
                    Navigator.pop(context, _selectedUser);
                  },
            child: const Text('Process'),
          ),
        ],
      ),
    );
  }
}
