import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/branch_repository.dart';
import 'branch_event.dart';
import 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepository;

  BranchBloc({required this.branchRepository}) : super(BranchInitial()){
    on<AddBranchEvent>(_onAddBranch);
    on<FetchBranchEvent>(_onFetchBranch);
  }

  Future<void> _onFetchBranch(FetchBranchEvent event, Emitter<BranchState> emit) async {
    emit(BranchFetchLoading());
    final result = await branchRepository.getAllBranch();
    result.fold(
          (failure) => emit(BranchFetchFailure(failure.message)),
          (branchList) => emit(BranchFetchSuccess(branchList)),
    );


  }


  Future<void> _onAddBranch(AddBranchEvent event, Emitter<BranchState> emit) async {
    emit(BranchAddLoading());
    final result = await branchRepository.addBranch(event.branchAddRequestDTO);

    result.fold(
          (failure) => emit(BranchAddFailure(failure.message)),
          (message) {
        emit(BranchAddSuccess(message));
        add(FetchBranchEvent());
      },
    );
  }
}