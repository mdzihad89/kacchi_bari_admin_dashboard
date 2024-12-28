import 'package:equatable/equatable.dart';

import '../../data/model/branch_add_request_dto.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object?> get props => [];
}

class AddBranchEvent extends BranchEvent {
  final BranchAddRequestDTO branchAddRequestDTO;

  const AddBranchEvent( this.branchAddRequestDTO);
  @override
  List<Object?> get props => [branchAddRequestDTO];
}

class FetchBranchEvent extends BranchEvent {
}
