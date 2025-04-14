import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';

abstract class StaffState extends Equatable {
  const StaffState();

  @override
  List<Object?> get props => [];
}

class StaffInitial extends StaffState {}

class StaffAddLoading extends StaffState {}
class StaffAddSuccess extends StaffState {
  const StaffAddSuccess();

  @override
  List<Object?> get props => [];
}
class StaffAddFailure extends StaffState {
  final String error;
  const StaffAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class StaffFetchLoading extends StaffState {}
class StaffFetchSuccess extends StaffState {
  final List<StaffModel> staffs;
  const StaffFetchSuccess(this.staffs);

  @override
  List<Object?> get props => [staffs];
}
class StaffFetchFailure extends StaffState {
  final String error;
  const StaffFetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class StaffUpdateLoading extends StaffState {}
class StaffUpdateSuccess extends StaffState {
  const StaffUpdateSuccess();
  @override
  List<Object?> get props => [];
}
class StaffUpdateFailure extends StaffState {
  final String error;
  const StaffUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}


class StaffDeleteLoading extends StaffState {}
class StaffDeleteSuccess extends StaffState {
  final String message;
  const StaffDeleteSuccess( this.message);
  @override
  List<Object?> get props => [ message];
}
class StaffDeleteFailure extends StaffState {
  final String error;
  const StaffDeleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class StaffCopyLoading extends StaffState {}

class StaffCopySuccess extends StaffState {}

class StaffCopyFailure extends StaffState {
  final String error;
  const StaffCopyFailure(this.error);

  @override
  List<Object?> get props => [error];
}