import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSelectPage extends ConsumerStatefulWidget {
  const UserSelectPage({super.key});

  @override
  ConsumerState<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends ConsumerState<UserSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('User Select Page')));
  }
}
