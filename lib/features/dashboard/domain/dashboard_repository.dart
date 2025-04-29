
import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/dashboard/data/model/top_selling_item.dart';
import '../../../core/network/failure.dart';
import '../data/model/order_report_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, OrderReport>> getSumOfNetPayable(String branchId, String date);
}