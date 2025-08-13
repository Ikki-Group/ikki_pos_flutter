import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../widgets/pos_cart_details.dart';
import '../widgets/pos_cart_list.dart';
import '../widgets/pos_filters.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: POSTheme.backgroundSecondary,
      child: Column(
        children: [
          PosFilters(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(flex: 5, child: PosCartList()),
                  SizedBox(width: 8),
                  Expanded(flex: 8, child: PosCartDetails()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
