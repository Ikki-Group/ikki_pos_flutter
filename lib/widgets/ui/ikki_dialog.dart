import 'package:flutter/material.dart';

class IkkiDialog extends StatelessWidget {
  const IkkiDialog({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class IkkiDialogTitle extends StatelessWidget {
  const IkkiDialogTitle({
    required this.title,
    super.key,
    this.icon = const Icon(
      Icons.play_arrow,
      color: Colors.white,
      size: 24,
    ),
  });

  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.orange[700],
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Row(
            spacing: 8,
            children: [
              icon,
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IkkiDialogContent {}

class IkkiDialogActions {}
