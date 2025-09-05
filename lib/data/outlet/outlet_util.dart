import 'outlet_model.dart';

extension OutletStateX on OutletStateModel {
  bool get isOpen => session != null;

  OutletSessionModel get requireOpen {
    if (isOpen) return session!;
    throw Exception('Outlet session is not open');
  }
}
