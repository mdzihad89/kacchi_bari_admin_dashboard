import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/data/model/product_model.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/product_add_request_dto.dart';

abstract class ProductRepository {
  Future<Either<Failure, String>> addProduct(ProductItemDTO productItemDTO);
  Future<Either<Failure, List<ProductModel>>> getAllProduct();

}