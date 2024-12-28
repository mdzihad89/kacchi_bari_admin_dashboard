import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/domain/repository/category_repository.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()){
    on<AddCategoryEvent>(_onAddCategory);
    on<FetchCategoryEvent>(_onFetchCategory);
  }

  Future<void> _onFetchCategory(FetchCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryFetchLoading());
    final result = await categoryRepository.getAllCategory();
    result.fold(
          (failure) => emit(CategoryFetchFailure(failure.message)),
          (employeeList) => emit(CategoryFetchSuccess(employeeList)),
    );


  }


  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryAddLoading());
    final result = await categoryRepository.addCategory(event.addCategoryRequestDto);

    result.fold(
          (failure) => emit(CategoryAddFailure(failure.message)),
          (message) {
        emit(CategoryAddSuccess(message));
        add(FetchCategoryEvent());
      },
    );
  }
}