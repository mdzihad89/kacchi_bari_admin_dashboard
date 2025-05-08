import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/error_handle.dart';
import '../../../core/network/failure.dart';
import '../domain/order_repository.dart';
import 'model/order_filter_model.dart';
import 'model/order_response_model.dart';

class OrderRepositoryImpl extends OrderRepository{
  final ApiService _apiService;

  OrderRepositoryImpl(this._apiService,);
  @override
  Future<Either<Failure, OrderResponse>> getAllOrder(OrderFilter orderFilter) async{
    try{
      final response = await _apiService.get(endPoint: "order/get-all-order", params: orderFilter.toJson());
      final data =  OrderResponse.fromJson(response.data);
      return Right(data);
    }catch(error){
      log(error.toString());
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> deleteOrder(List<String> orderIds) async{
    try{
      final response = await _apiService.post(endPoint: "order/delete-order", data: {"orderIds": orderIds});
      return Right(response.data["message"]);
    }catch(error){
      log(error.toString());
      return Left(ErrorHandler.handle(error).failure);
    }
  }



}