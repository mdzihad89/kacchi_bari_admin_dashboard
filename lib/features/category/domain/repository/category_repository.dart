import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/add-category_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/category_model.dart';

import '../../../../core/network/failure.dart';

abstract class CategoryRepository {
  Future<Either<Failure, String>> addCategory(AddCategoryRequestDto addCategoryRequestDto);
  Future<Either<Failure, List<CategoryModel>>> getAllCategory();
}