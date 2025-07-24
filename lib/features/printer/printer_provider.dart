import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'printer_model.dart';
import 'printer_repo.dart';

part 'printer_provider.g.dart';

@Riverpod(keepAlive: true)
class PrinterProvider extends _$PrinterProvider {
  @override
  List<PrinterModel> build() {
    load();
    return [];
  }

  Future<void> load() async {
    print('[PrinterProvider] load');
    final printers = await ref.read(printerRepoProvider).load();
    state = printers;
    print('[PrinterProvider] load done');
  }
}
