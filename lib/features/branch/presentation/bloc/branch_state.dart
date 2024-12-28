import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/model/branch_model.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object?> get props => [];
}

class BranchInitial extends BranchState {}

class BranchAddLoading extends BranchState {}

class BranchAddSuccess extends BranchState {
  final String message;
  const BranchAddSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchAddFailure extends BranchState {
  final String error;
  const BranchAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class BranchFetchLoading extends BranchState {}

class BranchFetchSuccess extends BranchState {
  final List<BranchModel> branches;
  const BranchFetchSuccess(this.branches);

  @override
  List<Object?> get props => [branches];
}

class BranchFetchFailure extends BranchState {
  final String error;
  const BranchFetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}