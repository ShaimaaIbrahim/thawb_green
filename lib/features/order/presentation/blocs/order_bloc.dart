import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/order/domain/entities/spec_order_item_entity.dart';
import 'package:ojos_app/features/order/domain/repositories/order_repository.dart';
import 'package:ojos_app/features/order/domain/usecases/get_orders.dart';

import '../../../../main.dart';

@immutable
abstract class OrderState extends Equatable {}

class OrderUninitializedState extends OrderState {
  @override
  String toString() => 'OrderUninitializedState';

  @override
  List<Object> get props => [];
}

class OrderLoadingState extends OrderState {
  @override
  String toString() => 'OrderLoadingState';

  @override
  List<Object> get props => [];
}

class OrderDoneState extends OrderState {
  final List<GeneralOrderItemEntity> orders;

  OrderDoneState({required this.orders});

  @override
  String toString() => 'OrderDoneState data ${orders.toString()}';

  @override
  List<Object> get props => [orders];
}

class OrderFailureState extends OrderState {
  final BaseError error;

  OrderFailureState(this.error);

  @override
  String toString() => 'OrderFailureState';

  @override
  List<Object> get props => [error];
}

@immutable
abstract class OrderEvent extends Equatable {}

class GetOrderEvent extends OrderEvent {
  final CancelToken cancelToken;
  final Map<String, String> filterParams;

  GetOrderEvent({
    required this.cancelToken,
    required this.filterParams,
  });

  @override
  List<Object> get props => [cancelToken, filterParams];
}

class DeleteOrderEvent extends OrderEvent {
  final CancelToken? cancelToken;
  final int? id;
  final Map<String, String>? filterparams;

  DeleteOrderEvent({this.cancelToken, this.id, required this.filterparams});

  @override
  List<Object?> get props => [id ?? 0, cancelToken ?? ''];
}

class DoneDeleteOrder extends OrderState {
  @override
  String toString() => 'DoneDeleteOrder';
  @override
  List<Object?> get props => [];
}

class FailureDeleteOrder extends OrderState {
  final BaseError? error;

  FailureDeleteOrder({this.error});

  @override
  String toString() => 'FailureDeleteOrder';
  @override
  List<Object?> get props => [];
}

class LoadingDeleteState extends OrderState {
  @override
  String toString() => 'LoadingDeleting data';

  @override
  List<Object> get props => [];
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderUninitializedState());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is GetOrderEvent) {
      yield OrderLoadingState();

      final result = await GetOrders(locator<OrderRepository>())(
        GetOrdersParams(
            cancelToken: event.cancelToken, filterParams: event.filterParams),
      );

      ///=============================  Succeed request app info remote ========================================
      if (result.hasDataOnly) {
        final List<GeneralOrderItemEntity> listOfResult = result.data!;
        // final List<SpecOrderItemEntity> listOfData = [];
        // if (listOfResult != null && listOfResult.isNotEmpty) {
        //   for (int i = 0; i < listOfResult.length; i++) {
        //     if (listOfResult[i].order_items != null &&
        //         listOfResult[i].order_items.isNotEmpty) {
        //       for (int j = 0; j < listOfResult[i].order_items.length; j++) {
        //         listOfData.add(SpecOrderItemEntity(
        //             user_id: listOfResult[i].user_id,
        //             id: listOfResult[i].id,
        //             user_address: listOfResult[i].user_address,
        //             uid: listOfResult[i].uid,
        //             tax: listOfResult[i].tax,
        //             shippingcarrier: listOfResult[i].shippingcarrier,
        //             shipping_id: listOfResult[i].shipping_id,
        //             shipping_fee: listOfResult[i].shipping_fee,
        //             price_discount: listOfResult[i].price_discount,
        //             point_map: listOfResult[i].point_map,
        //             payment_id: listOfResult[i].payment_id,
        //             orginal_price: listOfResult[i].orginal_price,
        //             order_number: listOfResult[i].order_number,
        //             order_items: listOfResult[i].order_items[j],
        //             note: listOfResult[i].note,
        //             discount: listOfResult[i].discount,
        //             delivery_zipcode: listOfResult[i].delivery_zipcode,
        //             delivery_state: listOfResult[i].delivery_state,
        //             delivery_phone: listOfResult[i].delivery_phone,
        //             delivery_city: listOfResult[i].delivery_city,
        //             delivery_address: listOfResult[i].delivery_address,
        //             coupon_id: listOfResult[i].coupon_id,
        //             billing_name: listOfResult[i].billing_name,
        //             status: listOfResult[i].status,
        //             total: listOfResult[i].total));
        //       }
        //     }
        //   }
        // }
        yield OrderDoneState(orders: listOfResult);
      } else {
        final error = result.error;
        yield OrderFailureState(error!);
      }
    }

    if (event is DeleteOrderEvent) {
      yield LoadingDeleteState();
      final result = await DeleteOrder(locator<OrderRepository>())(
          DeleteOrderParams(cancelToken: event.cancelToken, id: event.id!));

      if (result.hasDataOnly) {
        final result1 = await GetOrders(locator<OrderRepository>())(
            GetOrdersParams(
                cancelToken: event.cancelToken,
                filterParams: event.filterparams!));

        if (result1.hasDataOnly) {
          final List<GeneralOrderItemEntity> listOfResult = result1.data!;
          yield DoneDeleteOrder();
          yield OrderDoneState(orders: listOfResult);
        } else {
          final error = result1.error;
          yield FailureDeleteOrder(error: error);
        }
      } else {
        final error = result.error;
        yield FailureDeleteOrder(error: error);
      }
    }
  }
}
