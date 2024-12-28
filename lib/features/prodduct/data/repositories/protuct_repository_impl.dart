import 'package:dartz/dartz.dart';

import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';

import 'package:kacchi_bari_admin_dashboard/features/prodduct/data/model/product_add_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/data/model/product_model.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/error_handle.dart';
import '../../domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {

  final ApiService _apiService;
  const ProductRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, String>> addProduct(ProductItemDTO productItemDTO) async{

    try {
      final response = await _apiService.multiPartPost(endPoint: "food/create-food", data: productItemDTO.toJson());
      final message =  response.data['message'];
      return  Right(message);
    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProduct() async{
    try{
      final response = await _apiService.get(endPoint: "food/get-all-foods");
      final data = (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      return Right(data);
    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }

}