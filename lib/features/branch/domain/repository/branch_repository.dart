import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/model/branch_add_request_dto.dart';
import '../../data/model/branch_model.dart';

abstract class BranchRepository {
  Future<Either<Failure, String>> addBranch(BranchAddRequestDTO branchAddRequestDTO);
  Future<Either<Failure, List<BranchModel>>> getAllBranch();
}