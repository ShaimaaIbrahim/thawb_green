import 'package:dio/dio.dart';
import 'package:ojos_app/core/params/base_params.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/core/usecases/usecase.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/order/domain/repositories/order_repository.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/core/errors/base_error.dart';

class GetOrdersParams extends BaseParams {
  final Map<String, String> filterParams;
  final int? pagesize;
  final int? page;

  GetOrdersParams({
    required this.filterParams,
    this.pagesize,
    this.page,
    CancelToken? cancelToken,
  }) : super(cancelToken: cancelToken!);
}

class GetOrders extends UseCase<List<GeneralOrderItemEntity>, GetOrdersParams> {
  final OrderRepository repository;

  GetOrders(this.repository);

  @override
  Future<Result<BaseError, List<GeneralOrderItemEntity>>> call(
      GetOrdersParams params) {
    return repository.getOrders(
      pagesize: params.pagesize,
      page: params.page,
      filterParams: params.filterParams,
      cancelToken: params.cancelToken,
    );
  }
}

class GetOrdersOnline
    extends UseCase<List<GeneralOrderItemEntity>, GetOrdersParams> {
  final OrderRepository repository;

  GetOrdersOnline(this.repository);

  @override
  Future<Result<BaseError, List<GeneralOrderItemEntity>>> call(
      GetOrdersParams params) {
    return repository.getOrdersOnline(
      pagesize: params.pagesize,
      page: params.page,
      filterParams: params.filterParams,
      cancelToken: params.cancelToken,
    );
  }
}

class DeleteOrderParams extends BaseParams {
  int id;

  DeleteOrderParams({
    required this.id,
    CancelToken? cancelToken,
  }) : super(cancelToken: cancelToken!);
}

class DeleteOrder extends UseCase<Object, DeleteOrderParams> {
  final OrderRepository repository;

  DeleteOrder(this.repository);

  @override
  Future<Result<BaseError, Object>> call(DeleteOrderParams params) {
    return repository.deleteOrder(
      id: params.id,
      cancelToken: params.cancelToken,
    );
  }
}
