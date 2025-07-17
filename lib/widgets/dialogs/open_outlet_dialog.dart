// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../core/config/pos_theme.dart';
// import '../../data/outlet/outlet.model.dart';
// import '../../data/outlet/outlet_notifier.dart';
// import '../../data/user/user_notifier.dart';
// import '../../shared/utils/formatter.dart';
// import 'currency_numpad_dialog.dart';
// import '../ui/button_variants.dart';
// import '../ui/ikki_dialog.dart';

// class OpenOutletDialog extends ConsumerStatefulWidget {
//   const OpenOutletDialog({super.key});

//   static void show(BuildContext context) {
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const OpenOutletDialog();
//       },
//     );
//   }

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _OpenOutletDialogState();
// }

// class _OpenOutletDialogState extends ConsumerState<OpenOutletDialog> {
//   int _openingCash = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _onCashInPressed() async {
//     final val = await CurrencyNumpadDialog.show(
//       context,
//       initialValue: _openingCash,
//     );
//     if (val != null) {
//       setState(() {
//         _openingCash = val;
//       });
//     }
//   }

//   void void _onClose() {
//     Navigator.of(context).pop();
//   }

//   Future<void> _onProcessPressed() async {
//     final user = ref.read(userNotifierProvider);
//     ref
//         .read(outletNotifierProvider.notifier)
//         .setOpen(
//           OutletSessionOpen(
//             at: DateTime.now().toIso8601String(),
//             by: user!.name,
//             balance: _openingCash,
//           ),
//         );
//     _onClose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final outlet = ref.watch(outletNotifierProvider).requiredOutlet;
//     final user = ref.watch(userNotifierProvider);

//     return IkkiDialog(
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 400),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           spacing: 8,
//           children: [
//             const IkkiDialogTitle(title: 'Mulai Penjualan'),
//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   spacing: 4,
//                   children: [
//                     const Text('Kasir'),
//                     Text(
//                       user!.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('Outlet'),
//                     Text(
//                       outlet.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('Kas Awal'),
//                     SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton(
//                         onPressed: _onCashInPressed,
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: POSTheme.primaryBlueLight,
//                           side: const BorderSide(color: POSTheme.primaryBlueLight),
//                           shape: const LinearBorder(
//                             side: BorderSide(color: Colors.blue),
//                             bottom: LinearBorderEdge(),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                         ),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(Formatter.toIdr.format(_openingCash)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ThemedButton.cancel(
//                   onPressed: _onClose,
//                 ),
//                 const SizedBox(width: 8),
//                 ThemedButton.process(
//                   onPressed: _openingCash == 0 ? null : _onProcessPressed,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
