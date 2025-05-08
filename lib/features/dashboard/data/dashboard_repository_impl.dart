import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/api_service.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';
import 'package:kacchi_bari_admin_dashboard/features/dashboard/data/model/top_selling_item.dart';

import '../../../core/network/error_handle.dart';
import '../domain/dashboard_repository.dart';
import 'model/order_report_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final ApiService apiService;

  DashboardRepositoryImpl(this.apiService,);

  @override
  Future<Either<Failure, OrderReport>> getSumOfNetPayable(String branchId, String localStartTime, String localEndTime) async{
    try {
      final response = await apiService.get( endPoint: "order/get-order-report", params: {
        "branchId": branchId,
        "startTime": localStartTime,
        "endTime": localEndTime
      });
        return Right(OrderReport.fromJson(response.data));

    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

  }




}