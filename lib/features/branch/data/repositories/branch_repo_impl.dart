import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/model/branch_add_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/model/branch_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/domain/repository/branch_repository.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/error_handle.dart';

class BranchRepositoryImpl extends BranchRepository{
  final ApiService _apiService;

  BranchRepositoryImpl(this._apiService);
  @override
  Future<Either<Failure, String>> addBranch(BranchAddRequestDTO branchAddRequestDTO)async {

    try {
      final response = await _apiService.multiPartPost(endPoint: "branch/create-branch", data: branchAddRequestDTO.toMap());
      final message =  response.data['message'];
      return  Right(message);
    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<BranchModel>>> getAllBranch() async{
    try{
      final response = await _apiService.get(endPoint: "branch/get-all-branch");
      final data = (response.data as List).map((e) => BranchModel.fromJson(e)).toList();

      return Right(data);
    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }

}