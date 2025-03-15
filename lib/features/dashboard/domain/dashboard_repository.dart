
import 'package:dartz/dartz.dart';

import '../../../core/network/failure.dart';

abstract class DashboardRepository {
  Future<Either<Failure, String>> getSumOfNetPayable(String branchId, String date);
}