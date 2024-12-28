import 'package:equatable/equatable.dart';

import '../../data/model/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryAddLoading extends CategoryState {}

class CategoryAddSuccess extends CategoryState {
  final String message;
  const CategoryAddSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryAddFailure extends CategoryState {
  final String error;
  const CategoryAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CategoryFetchLoading extends CategoryState {}

class CategoryFetchSuccess extends CategoryState {
  final List<CategoryModel> categories;
  const CategoryFetchSuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryFetchFailure extends CategoryState {
  final String error;
  const CategoryFetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}