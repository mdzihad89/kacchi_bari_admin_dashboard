import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/add-category_request_dto.dart';

import '../../data/model/product_add_request_dto.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class AddProductEvent extends ProductEvent {
  final ProductItemDTO productItemDTO;

  const AddProductEvent( this.productItemDTO);
  @override
  List<Object?> get props => [productItemDTO];
}

class FetchProductEvent extends ProductEvent {
}
