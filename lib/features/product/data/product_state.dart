import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/product_model.dart';
import '../../../utils/json.dart';

part 'product_state.freezed.dart';
part 'product_state.g.dart';

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    required List<ProductModel> products,
    required List<ProductCategoryModel> categories,
  }) = _ProductState;

  factory ProductState.fromJson(Json json) => _$ProductStateFromJson(json);
}
