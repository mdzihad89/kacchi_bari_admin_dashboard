import 'package:dartz/dartz.dart';
import '../../../core/network/failure.dart';
import '../data/model/order_filter_model.dart';
import '../data/model/order_response_model.dart';

abstract class OrderRepository{
  Future<Either<Failure,OrderResponse>> getAllOrder( OrderFilter orderFilter);
  Future<Either<Failure,String>> deleteOrder(List<String> orderIds);
}