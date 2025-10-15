import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider.dart';

class PlaygroundPage extends ConsumerStatefulWidget {
  const PlaygroundPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends ConsumerState<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    final foo = ref.watch(fooProvider);
    foo.whenData((data) {
      log(data);
    });

    return Container();
  }
}
