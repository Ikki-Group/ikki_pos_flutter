import 'product.model.dart';

extension ProductX on ProductModel {
  bool get hasVariant => variants.isNotEmpty;
}
