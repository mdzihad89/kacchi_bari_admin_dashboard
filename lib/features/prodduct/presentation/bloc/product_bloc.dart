import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/domain/repository/category_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/domain/repository/product_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/presentation/bloc/product_event.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/presentation/bloc/product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()){
    on<AddProductEvent>(_onAddProduct);
    on<FetchProductEvent>(_onFetchProduct);
  }

  Future<void> _onFetchProduct(FetchProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductFetchLoading());
    final result = await productRepository.getAllProduct();
    result.fold(
          (failure) => emit(ProductFetchFailure(failure.message)),
          (employeeList) => emit(ProductFetchSuccess(employeeList)),
    );


  }


  Future<void> _onAddProduct(AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductAddLoading());
    final result = await productRepository.addProduct(event.productItemDTO);

    result.fold(
          (failure) => emit(ProductAddFailure(failure.message)),
          (message) {
        emit(ProductAddSuccess(message));
        add(FetchProductEvent());
      },
    );
  }
}