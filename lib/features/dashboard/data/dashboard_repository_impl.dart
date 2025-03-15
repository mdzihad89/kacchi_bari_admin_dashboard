import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/api_service.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';

import '../../../core/network/error_handle.dart';
import '../domain/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final ApiService apiService;

  DashboardRepositoryImpl(this.apiService,);

  @override
  Future<Either<Failure, String>> getSumOfNetPayable(String branchId, String date) async{
    try {
      final response = await apiService.get( endPoint: "order/sum-netpayable-amount?branchId=$branchId&date=$date");
      return Right( response.data['totalNetPayableAmount'].toString());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

  }


}