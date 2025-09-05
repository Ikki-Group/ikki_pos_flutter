import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';

class PosDialogTwo extends StatelessWidget {
  const PosDialogTwo({super.key, this.title, this.children, this.footer, this.constraints, this.width, this.height});

  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final String? title;
  final List<Widget>? children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    Widget? headerWidget;

    if (title != null) {
      headerWidget = ColoredBox(
        color: POSTheme.primaryBlue,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    Widget? contentWidget;

    if (children != null) {
      contentWidget = Flexible(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: SingleChildScrollView(
            child: ListBody(
              children: children!,
            ),
          ),
        ),
      );
      // contentWidget = Padding(
      //   padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      //   child: SingleChildScrollView(
      //     child: ListBody(
      //       children: children!,
      //     ),
      //   ),
      // );
    }

    Widget? footerWidget;

    if (footer != null) {
      footerWidget = Padding(
        padding: const EdgeInsets.all(12),
        child: footer,
      );
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (headerWidget != null) headerWidget,
          if (contentWidget != null) contentWidget,
          if (footerWidget != null) footerWidget,
        ],
      ),
    );

    if (constraints != null) {
      dialogChild = ConstrainedBox(
        constraints: constraints!,
        child: dialogChild,
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: dialogChild,
      // child: Container(
      //   width: width,
      //   height: height,
      //   constraints: constraints,
      //   clipBehavior: Clip.antiAlias,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(12),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withValues(alpha: .2),
      //         blurRadius: 20,
      //         offset: const Offset(0, 8),
      //       ),
      //     ],
      //   ),
      //   child: dialogChild,
      // ),
    );
  }
}
