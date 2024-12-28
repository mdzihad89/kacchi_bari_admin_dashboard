import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/add-category_request_dto.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class AddCategoryEvent extends CategoryEvent {
  final AddCategoryRequestDto addCategoryRequestDto;

  const AddCategoryEvent( this.addCategoryRequestDto);
  @override
  List<Object?> get props => [addCategoryRequestDto];
}

class FetchCategoryEvent extends CategoryEvent {
}
