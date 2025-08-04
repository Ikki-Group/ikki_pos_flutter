import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';

class PosDialog extends StatelessWidget {
  const PosDialog({
    required this.title,
    required this.children,
    super.key,
    this.subtitle,
    this.width,
    this.height,
    this.footer,
    this.scrollable = true,
    this.constraints = const BoxConstraints(),
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? footer;

  final bool scrollable;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final textTheme = Theme.of(context).textTheme;

    final Widget titleWidget = ColoredBox(
      color: POSTheme.primaryBlue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
          ],
        ),
      ),
    );

    Widget contentWidget;

    if (scrollable) {
      contentWidget = Flexible(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ListBody(
            children: children,
          ),
        ),
      );
    } else {
      contentWidget = Padding(
        padding: const EdgeInsets.all(16),
        child: ListBody(
          children: children,
        ),
      );
    }

    Widget? footerWidget;

    if (footer != null) {
      footerWidget = Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: footer,
      );
    }

    Widget dialogChild;
    dialogChild = ConstrainedBox(
      constraints: constraints!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          titleWidget,
          contentWidget,
          if (footerWidget != null) footerWidget,
        ],
      ),
    );

    return Dialog(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: const Color.fromARGB(157, 0, 0, 0),
      // insetPadding: isKeyboardVisible ? const EdgeInsets.symmetric(horizontal: 16) : const EdgeInsets.all(16),
      child: dialogChild,
    );
  }
}
