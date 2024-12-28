import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/data/model/product_model.dart';


abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductAddLoading extends ProductState {}

class ProductAddSuccess extends ProductState {
  final String message;
  const ProductAddSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductAddFailure extends ProductState {
  final String error;
  const ProductAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProductFetchLoading extends ProductState {}

class ProductFetchSuccess extends ProductState {
  final List<ProductModel> products;
  const ProductFetchSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductFetchFailure extends ProductState {
  final String error;
  const ProductFetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}