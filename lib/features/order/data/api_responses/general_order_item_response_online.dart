import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/models/category_model.dart';
import 'package:ojos_app/core/responses/api_response.dart';
import 'package:ojos_app/features/order/data/models/general_order_item_model.dart';
import 'package:ojos_app/features/order/data/models/general_order_item_model_online.dart';
import 'package:ojos_app/features/product/data/models/product_model.dart';

part 'general_order_item_response_online.g.dart';

@JsonSerializable()
class GeneralOrderItemResponse1 extends ApiResponse<List<GeneralOrderItemModel1>> {
  GeneralOrderItemResponse1(
    bool status,
    String msg,
    List<GeneralOrderItemModel1> result,
  ) : super(status, msg, result);

  factory GeneralOrderItemResponse1.fromJson(Map<String, dynamic> json) =>
      _$GeneralOrderItemResponse1FromJson(json);
}
