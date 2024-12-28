import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/category_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/domain/repository/category_repository.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/error_handle.dart';
import '../../../../core/network/failure.dart';
import '../model/add-category_request_dto.dart';

class CategoryRepositoryImpl extends CategoryRepository{


  final ApiService _apiService;

  CategoryRepositoryImpl(this._apiService);
  @override
  Future<Either<Failure, String>> addCategory(AddCategoryRequestDto addCategoryRequestDto)async {

    try {
      final response = await _apiService.multiPartPost(endPoint: "category/create-category", data: addCategoryRequestDto.toMap());
      final message =  response.data['message'];
      return  Right(message);
    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategory() async{
    try{
      final response = await _apiService.get(endPoint: "category/get-all-category");
      final data = (response.data as List).map((e) => CategoryModel.fromJson(e)).toList();
      return Right(data);
    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}