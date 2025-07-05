import 'package:flutter/material.dart';
import 'package:ikki_pos_flutter/features/home/manager/home_tab_item.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: DefaultTabController(
            length: 4,
            child: TabBar(
              tabs: [
                for (var item in HomeTabItem.values) Tab(text: item.label),
              ],
              labelColor: Colors.blueAccent,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              suffixIcon: Icon(Icons.clear, color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }
}
