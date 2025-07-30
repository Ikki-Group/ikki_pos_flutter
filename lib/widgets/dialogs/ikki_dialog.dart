import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';

class IkkiDialog extends StatelessWidget {
  const IkkiDialog({
    required this.child,
    this.title,
    this.footer,
    super.key,
    this.mainAxisSize = MainAxisSize.max,
    this.width,
    this.constraints = const BoxConstraints(maxWidth: 500),
  });

  final String? title;
  final Widget? child;
  final Widget? footer;
  final MainAxisSize mainAxisSize;
  final double? width;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    Widget? header;

    if (title != null && title!.isNotEmpty) {
      header = Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: POSTheme.primaryBlue),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Dialog(
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.9,
        constraints: constraints,
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
          mainAxisSize: mainAxisSize,
          children: [
            if (header != null) header,
            const SizedBox(height: 8),
            if (child != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: child,
              ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}
