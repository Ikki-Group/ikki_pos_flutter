// import 'package:flutter/material.dart';

// import '../../core/config/pos_theme.dart';

// enum SnackbarType {
//   success,
//   error,
// }

// class PosSnackbar extends StatelessWidget implements SnackBar {
//   const PosSnackbar({
//     required this.text,
//     this.type = SnackbarType.success,
//     super.key,
//   });

//   final String text;
//   final SnackbarType type;

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     const foregroundColor = POSTheme.textOnPrimary;
//     final backgroundColor = type == SnackbarType.success ? POSTheme.statusError : POSTheme.statusError;

//     return SnackBar(
//       content: Text(text, style: textTheme.labelMedium?.copyWith(color: foregroundColor)),
//       backgroundColor: backgroundColor,
//     );
//   }
  
//   @override
//   // TODO: implement action
//   SnackBarAction? get action => throw UnimplementedError();
  
//   @override
//   // TODO: implement actionOverflowThreshold
//   double? get actionOverflowThreshold => throw UnimplementedError();
  
//   @override
//   // TODO: implement animation
//   Animation<double>? get animation => throw UnimplementedError();
  
//   @override
//   // TODO: implement backgroundColor
//   Color? get backgroundColor => throw UnimplementedError();
  
//   @override
//   // TODO: implement behavior
//   SnackBarBehavior? get behavior => throw UnimplementedError();
  
//   @override
//   // TODO: implement clipBehavior
//   Clip get clipBehavior => throw UnimplementedError();
  
//   @override
//   // TODO: implement closeIconColor
//   Color? get closeIconColor => throw UnimplementedError();
  
//   @override
//   // TODO: implement content
//   Widget get content => throw UnimplementedError();
  
//   @override
//   State<SnackBar> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
  
//   @override
//   // TODO: implement dismissDirection
//   DismissDirection? get dismissDirection => throw UnimplementedError();
  
//   @override
//   // TODO: implement duration
//   Duration get duration => throw UnimplementedError();
  
//   @override
//   // TODO: implement elevation
//   double? get elevation => throw UnimplementedError();
  
//   @override
//   // TODO: implement hitTestBehavior
//   HitTestBehavior? get hitTestBehavior => throw UnimplementedError();
  
//   @override
//   // TODO: implement margin
//   EdgeInsetsGeometry? get margin => throw UnimplementedError();
  
//   @override
//   // TODO: implement onVisible
//   VoidCallback? get onVisible => throw UnimplementedError();
  
//   @override
//   // TODO: implement padding
//   EdgeInsetsGeometry? get padding => throw UnimplementedError();
  
//   @override
//   // TODO: implement shape
//   ShapeBorder? get shape => throw UnimplementedError();
  
//   @override
//   // TODO: implement showCloseIcon
//   bool? get showCloseIcon => throw UnimplementedError();
  
//   @override
//   // TODO: implement width
//   double? get width => throw UnimplementedError();
  
//   @override
//   SnackBar withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) {
//     // TODO: implement withAnimation
//     throw UnimplementedError();
//   }
// }
